# GovCon 2025 Testing Suite Menu

## Overview

The `scripts-menu.sh` file provides a user-friendly command-line interface to run all the testing tools in the GovCon 2025 project. This menu system simplifies the execution of complex Docker commands and provides educational context for each testing tool.

## Prerequisites

- Docker must be installed and running
- Execute permissions on the script (already set)

## Usage

From the project root directory, run:

```bash
./scripts-menu.sh
```

## Menu Options

### 1. Visual Regression Testing (BackstopJS)

Captures and compares screenshots across different viewports to detect visual changes.

**Sub-options:**
- Create reference images (required for first-time setup)
- Run visual regression tests
- Approve changes (update reference images)

### 2. Security Scanning (OWASP ZAP)

Scans URLs from `scripts/508-test-pages.json` for security vulnerabilities.

**Features:**
- Automated scanning of multiple URLs
- HTML reports generated for each domain
- Results saved in `zap-results/` directory

### 3. Code Quality Testing

Enforces coding standards and best practices.

**Sub-options:**
- PHP_CodeSniffer (PSR-12 standard)
- ESLint (JavaScript linting)
- Run both tools together

### 4. Link Validation (Lychee)

Checks for broken links in the project documentation and sitemap.

**Features:**
- Validates URLs in `scripts/load_test_sitemap.xml`
- Identifies broken or redirected links

### 5. Accessibility Testing (Axe-core)

Tests for Section 508 and WCAG compliance.

**Sub-options:**
- Run local tests (requires Node.js)
- View GitHub Actions workflow instructions

### 6. Service Management

Manage the Docker services used by the testing suite.

**Sub-options:**
- Start web server (port 8090)
- Stop all services
- View running services status

### 7. View Test Reports

Quick access to generated test reports.

**Features:**
- Check for available reports
- Open BackstopJS report in browser
- List all report file locations

## Color Coding

The menu uses color codes for better readability:
- 🔵 **Blue**: Headers and informational text
- 🟢 **Green**: Success messages and confirmations
- 🟡 **Yellow**: Warnings and important notices
- 🔴 **Red**: Errors and invalid options

## Error Handling

The script includes several safety features:
- Docker availability check on startup
- Confirmation prompts for destructive actions
- Clear error messages for invalid options
- Graceful handling of missing reports or files

## Tips for Presenters

1. **Start with Service Management**: Ensure the web server is running before demonstrating other tools
2. **Visual Regression Demo**: Always create reference images first
3. **Show Reports**: Use option 7 to quickly demonstrate test results
4. **Educational Context**: Each tool includes a brief description of its purpose

## Troubleshooting

**"Docker is not running" error**
- Start Docker Desktop or the Docker daemon
- Verify with: `docker info`

**"Permission denied" error**
- Ensure the script is executable: `chmod +x scripts-menu.sh`
- Run from the project root directory

**Reports not found**
- Run the respective tests first
- Check the correct directories for output files

## Integration with CI/CD

While this menu is designed for local/demo use, the same Docker commands can be integrated into CI/CD pipelines. See the `.github/workflows/` directory for GitHub Actions examples.

---

*Part of the GovCon 2025 Automation Testing Suite - Educational resource for government contractors*
