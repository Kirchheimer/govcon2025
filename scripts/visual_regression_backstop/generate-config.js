const fs = require('fs');
const path = require('path');

// Define paths
const urlsFilePath = path.join(__dirname, '../../scripts/508-test-pages.json');
const backstopConfigOutputPath = path.join(__dirname, './backstop.json');

try {
  // Read the list of URLs
  const urls = JSON.parse(fs.readFileSync(urlsFilePath, 'utf8'));
  
  // Create scenarios from the URLs
  const scenarios = urls.map(url => {
    // Create a clean label from the URL
    const label = url
      .replace(/https?:\/\//, '')  // Remove protocol
      .replace(/\/$/, '')          // Remove trailing slash
      .replace(/[\/\.\:]/g, '_')   // Replace special chars with underscore
      .substring(0, 50);           // Limit length for readability
    
    return {
      label: label,
      url: url,
      delay: 1000,                 // Increased delay for external sites
      misMatchThreshold: 0.1,
      requireSameDimensions: true
    };
  });

  // Define the BackstopJS configuration
  const backstopConfig = {
    "id": "govcon_visual_regression_external_sites",
    "viewports": [
      {
        "label": "phone",
        "width": 375,
        "height": 667
      },
      {
        "label": "tablet",
        "width": 768,
        "height": 1024
      },
      {
        "label": "desktop",
        "width": 1920,
        "height": 1080
      }
    ],
    "scenarios": scenarios,
    "paths": {
      "bitmaps_reference": "backstop_data/bitmaps_reference",
      "bitmaps_test": "backstop_data/bitmaps_test",
      "engine_scripts": "backstop_data/engine_scripts",
      "html_report": "backstop_data/html_report",
      "ci_report": "backstop_data/ci_report"
    },
    "report": ["browser"],
    "engine": "puppeteer",
    "engineOptions": {
      "args": ["--no-sandbox", "--disable-setuid-sandbox"],
      "gotoParameters": {
        "waitUntil": ["load", "networkidle0"],
        "timeout": 30000
      }
    },
    "asyncCaptureLimit": 5,
    "asyncCompareLimit": 50,
    "debug": false,
    "debugWindow": false
  };

  // Write the final config file
  fs.writeFileSync(backstopConfigOutputPath, JSON.stringify(backstopConfig, null, 2));

  console.log(`✅ BackstopJS config generated successfully!`);
  console.log(`📋 Generated ${scenarios.length} test scenarios from ${urlsFilePath}`);
  console.log(`📁 Config saved to: ${backstopConfigOutputPath}`);
  
  // Display the scenarios that will be tested
  console.log('\n🎯 Test scenarios:');
  scenarios.forEach((scenario, index) => {
    console.log(`   ${index + 1}. ${scenario.label} -> ${scenario.url}`);
  });
  
} catch (error) {
  console.error('❌ Error generating BackstopJS config:', error.message);
  process.exit(1);
}
