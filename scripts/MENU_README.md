# GovCon 2025 Testing Suite Menu

## Overview

The project includes two menu scripts:

1. **`scripts-menu.sh`** - Docker-based menu that runs all tests in isolated containers
2. **`scripts-menu-node.sh`** - Node.js-based menu that runs commands directly from GitHub workflows

Both menu systems provide a user-friendly command-line interface to run all the testing tools in the GovCon 2025 project, simplifying the execution of complex commands and providing educational context for each testing tool.

## Prerequisites

### For Docker Menu (`scripts-menu.sh`)
- Docker must be installed and running
- Execute permissions on the script (already set)

### For Node.js Menu (`scripts-menu-node.sh`)
- Node.js installed (v18 or higher recommended)
- Execute permissions on the script (already set)
- Some tools require additional installation (PHP, Lychee, etc.)

## Usage

### Docker-based Menu
```bash
./scripts-menu.sh
```

### Node.js-based Menu
```bash
./scripts-menu-node.sh
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

## Differences Between Menu Versions

### Docker Menu (`scripts-menu.sh`)
- **Pros**: No local dependencies needed, consistent environment
- **Cons**: Requires Docker, slower startup
- **Best for**: Demonstrations, consistent testing environments

### Node.js Menu (`scripts-menu-node.sh`)
- **Pros**: Faster execution, uses exact GitHub Actions commands
- **Cons**: Requires local tool installation
- **Best for**: Development, debugging GitHub Actions locally

## Integration with CI/CD

Both menus are designed for local/demo use:
- The Docker menu uses the same containers as `docker-composer-508.yml`
- The Node.js menu runs the exact commands from GitHub Actions workflows

See the `.github/workflows/` directory for the original GitHub Actions implementations.

## GitHub Actions Branch Triggers

The Node.js menu displays information about triggering GitHub Actions:
- Accessibility (Axe): `testbot/508-test-run`
- Accessibility (Pa11y): `testbot/508-pa11y-test-run`
- Lighthouse CI: `testbot/lighthouse-test-run`
- ESLint: `testbot/eslint-test-run`
- PHP_CodeSniffer: `testbot/phpcs-test-run`
- HTMLHint: `testbot/htmlhint-test-run`
- Link Checker: `testbot/linkchecker-test-run`
- OWASP ZAP: `testbot/security-test-run`

---

*Part of the GovCon 2025 Automation Testing Suite - Educational resource for government contractors*
