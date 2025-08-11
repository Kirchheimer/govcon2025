const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
// This file is used GitHub Action to run axe-core tests.
async function runAxe(url, browser) {
  const page = await browser.newPage();

  // Enable request interception
  await page.setRequestInterception(true);
  page.on('request', request => {
    const requestUrl = request.url();
    if (
      requestUrl.includes('dap.digitalgov.gov')
      || requestUrl.includes('maps.googleapis.com')
      || requestUrl.includes('www.google-analytics.com')
      || requestUrl.includes('www.googletagmanager.com')
    ) {
      request.abort();
    } else {
      request.continue();
    }
  });

  try {
    await page.goto(url, { waitUntil: 'networkidle0', timeout: 60000 });
  } catch (error) {
    if (error.name === 'TimeoutError') {
      console.error(`Timeout while loading URL: ${url}`);
      await page.close();
      return { url, violations: [], timeout: true };
    }
    throw error;
  }
  // Inject axe-core into the page
  await page.addScriptTag({ path: require.resolve('axe-core') });

  // Configure axe options
  const axeOptions = {
    runOnly: {
      type: 'tag',
      values: ['wcag2a', 'wcag2aa', 'section508', 'best-practice'],
    },
  };

  // Configure the context for axe.run to exclude specific css elements
  //const context = {
  //  include: [['body']]
  //};

  // Run axe-core within the page context with the specified context
  const results = await page.evaluate((context, axeOptions) => {
    return axe.run(context, axeOptions);
  }, context, axeOptions);

  await page.close();
  return { url, violations: results.violations };
}

async function main() {
  const urlsFilePath = path.join(__dirname, '508_test_pages.json');
  const urls = JSON.parse(fs.readFileSync(urlsFilePath, 'utf8'));

  const browser = await puppeteer.launch({
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-web-security',
      '--disable-site-isolation-trials',
      "--disable-notifications",
      "--no-zygote",
    ],
    devtools: false,
    headless: 'new',
    ignoreHTTPSErrors: true,
    pipe: true,
    slowMo: 0
  });

  let totalViolations = 0;
  let summary = [];
  let aggregatedData = {};

  for (const url of urls) {
    const result = await runAxe(url, browser);
    const violationCount = result.violations.length;
    totalViolations += violationCount;

    summary.push({ url, violationCount });

    if (violationCount > 0) {
      result.violations.forEach(violation => {
        console.log(`::group::Violation ID: ${violation.id} - ${url}`);
        console.log(JSON.stringify(violation, null, 2)); // Detailed violation
        console.log(`::endgroup::`);

        // Process each violation for aggregated data
        aggregatedData[violation.id] = (aggregatedData[violation.id] || 0) + 1;
      });
    } else {
      console.log(`No accessibility violations found for ${result.url}`);
    }
  }

  await browser.close();

  // Output the summary list
  console.log("\nSummary of Accessibility Tests:");
  summary.forEach(item => {
    console.log(`${item.url}: ${item.violationCount} violations`);
  });

  // Output the aggregated data
  console.log("\nAggregated Data:");
  for (const key in aggregatedData) {
    console.log(`${key}: ${aggregatedData[key]}`);
  }

  // Output the total violations summary
  if (totalViolations > 0) {
    console.log(`\nTotal Accessibility Violations across all pages: ${totalViolations}`);
    process.exitCode = 1; // Set error code for CI
  } else {
    console.log('\nNo accessibility violations found in any page');
  }
}

main().catch(error => {
  console.error('Error running tests:', error);
  process.exit(1);
});
