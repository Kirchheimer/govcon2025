# Visual Regression Testing with BackstopJS

## Overview

Visual regression testing is a critical component of the GovCon 2025 testing suite that helps detect unintended visual changes in web applications. This implementation uses BackstopJS to automatically capture screenshots of web pages across different viewports and compare them against baseline reference images.

## What is Visual Regression Testing?

Visual regression testing catches CSS, layout, and rendering issues that traditional testing methods might miss. It's particularly valuable for:

- Detecting unintended style changes after code updates
- Ensuring responsive design consistency across devices
- Validating that UI components render correctly
- Catching browser-specific rendering issues
- Maintaining visual consistency during refactoring

## How It Works

1. **Reference Images**: Initial screenshots are captured as the "truth" baseline
2. **Test Images**: New screenshots are taken after changes
3. **Comparison**: BackstopJS compares pixels between reference and test images
4. **Reporting**: Differences are highlighted in an interactive HTML report

## Configuration

### Dynamic URL Loading

The system dynamically generates test scenarios from `scripts/508-test-pages.json`. This allows easy management of test URLs without modifying the BackstopJS configuration directly.

**Current test URLs:**
- https://about.google/
- https://blog.google/inside-google/doodles/
- https://blog.google/outreach-initiatives/public-policy/

### Viewports

Tests run across three standard viewports:
- **Phone**: 375x667 (iPhone 6/7/8 size)
- **Tablet**: 768x1024 (iPad portrait)
- **Desktop**: 1920x1080 (Full HD)

### Key Settings

- **Delay**: 1000ms - Allows time for dynamic content to load
- **Mismatch Threshold**: 0.1 (10%) - Tolerance for minor rendering differences
- **Engine**: Puppeteer - Headless Chrome for consistent rendering
- **Async Limits**: 5 captures / 50 comparisons - Optimized for performance

## Usage Instructions

### Running with Docker (Recommended)

All commands use the Docker Compose configuration to ensure consistency:

#### Important: First Time Setup

When running BackstopJS for the first time, or after changing the test configuration, you MUST create reference images before running tests. Without reference images, all tests will fail with "Reference image not found" errors.

#### 1. Create Reference Images (First Time Setup)

```bash
docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=reference backstop
```

This captures baseline screenshots for all configured URLs and viewports.

#### 2. Run Visual Regression Tests

```bash
docker-compose -f docker-composer-508.yml run --rm backstop
```

This captures new screenshots and compares them against the references. (Default command is 'test')

#### 3. Approve Changes (Update References)

If the visual changes are intentional:

```bash
docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=approve backstop
```

This promotes the current test images to become the new reference images.

### Manual Commands (Advanced)

If you need to run specific BackstopJS commands:

```bash
# Open the interactive report
docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=openReport backstop

# Run with explicit test command
docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=test backstop
```

## Understanding the Results

### Report Location

After running tests, reports are generated in:
- `backstop_data/html_report/index.html` - Interactive HTML report
- `backstop_data/bitmaps_test/` - Test screenshots
- `backstop_data/bitmaps_reference/` - Reference screenshots

### Report Features

The HTML report provides:
- **Side-by-side comparison** of reference vs test images
- **Diff overlay** highlighting changed pixels
- **Scrubber tool** to slide between images
- **Pass/Fail status** for each scenario
- **Detailed metrics** about differences

### Interpreting Results

- **Green scenarios**: No visual changes detected
- **Red scenarios**: Visual differences exceed the threshold
- **Diff view**: Pink highlights show changed areas
- **Percentage**: Shows how much of the image changed

## File Structure

```
scripts/visual_regression_backstop/
├── README.md                    # This documentation
├── generate-config.js           # Dynamic config generator
├── backstop.json               # Generated BackstopJS configuration
└── backstop_data/
    ├── bitmaps_reference/      # Baseline screenshots
    ├── bitmaps_test/           # Latest test screenshots
    └── html_report/            # Interactive test reports
```

## Troubleshooting

### Common Issues

**1. "Reference file not found" error**
- **Solution**: Run `docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=reference backstop` first
- **Note**: If you've changed the test configuration (different URLs or ID), you'll need to create new reference images. The old reference images won't match the new naming convention.

**2. Tests failing on unchanged pages**
- **Cause**: Dynamic content (ads, timestamps, animations)
- **Solution**: Increase delay or add page-specific selectors to ignore

**3. Docker permission errors**
- **Solution**: Ensure Docker daemon is running and you have proper permissions

**4. Out of memory errors**
- **Solution**: Reduce `asyncCaptureLimit` in configuration

**5. Network timeouts**
- **Solution**: Increase `gotoParameters.timeout` in `generate-config.js`

### Best Practices

1. **Regular Updates**: Update reference images when intentional changes are made
2. **Review Reports**: Always review the HTML report before approving changes
3. **Version Control**: Commit reference images to track visual history
4. **CI Integration**: Run tests automatically on pull requests
5. **Selective Testing**: Use specific selectors for dynamic content areas

## Integration with CI/CD

While this setup focuses on local Docker testing, BackstopJS can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions step
- name: Run Visual Regression Tests
  run: |
    docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=reference backstop
    docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=test backstop
```

## Extending the Tests

### Adding New URLs

1. Edit `scripts/508-test-pages.json`
2. Add new URLs to the array
3. Re-run the tests - the config regenerates automatically

### Customizing Scenarios

To add custom scenarios with specific selectors or actions, modify `generate-config.js`:

```javascript
scenarios.push({
  label: "Custom_Scenario",
  url: "https://example.com",
  selectors: ["#specific-element"],
  clickSelector: ".button-to-click",
  delay: 2000
});
```

## Resources

- [BackstopJS Documentation](https://github.com/garris/BackstopJS)
- [Puppeteer Documentation](https://pptr.dev/)
- [Visual Regression Testing Best Practices](https://www.browserstack.com/guide/visual-regression-testing)

---

*Part of the GovCon 2025 Automation Testing Suite - Educational resource for government contractors*
