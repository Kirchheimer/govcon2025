# GitHub Actions Workflows

This directory contains all the GitHub Actions workflows for the GovCon 2025 Automation Testing Suite. These workflows automate a variety of testing and validation tasks, ensuring code quality, security, and compliance.

## Workflow Overview

-   **`accessibility-axe.yml`**: Runs Axe-core for accessibility testing against a list of URLs defined in `scripts/508-test-pages.json`.
-   **`accessibility-Pa11y.yml`**: Runs Pa11y for an alternative accessibility scan.
-   **`code-quality-eslint.yml`**: Lints all JavaScript and TypeScript files using ESLint.
-   **`code-quality-phpcs.yml`**: Lints all PHP files using PHP_CodeSniffer with the PSR-12 standard.
-   **`lighthouse-ci.yml`**: Performs performance, SEO, and best practices audits using Lighthouse.
-   **`security-owasp-zap.yml`**: Conducts security vulnerability scanning using OWASP ZAP.
-   **`validation-htmlhint.yml`**: Validates all HTML files using HTMLHint.
-   **`validation-linkchecker.yml`**: Checks for broken links in all Markdown and HTML files using Lychee.

## Triggers

Most workflows are configured to run on:
-   Pushes to specific `testbot/` branches for isolated testing.
-   Pull requests targeting the `main` and `develop` branches.

Please refer to the individual workflow files for specific trigger conditions.
