# GovCon 2025 - Automation Testing Suite

Welcome to the GovCon 2025 Automation Testing Suite! This project is an educational resource designed to demonstrate a comprehensive, modern, and containerized testing pipeline for government and enterprise projects.

## 🚀 Project Goals

- **Zero Local Dependencies**: All tools run inside Docker containers, ensuring a consistent and reproducible testing environment.
- **Open Source**: Utilizes a suite of powerful, free, and open-source testing tools.
- **Easy Integration**: Designed to be easily imported and adapted into existing development workflows.
- **Educational Focus**: Provides clear, well-documented examples for learning and presentation at GovCon 2025.
- **CI/CD Demonstration**: Showcases modern continuous integration and deployment practices using GitHub Actions.

## 🏗️ Project Architecture

This project is divided into two main testing groups:

1.  **Server-side Testing (GitHub Actions)**: Automated checks that run in the cloud during your CI/CD pipeline (e.g., on pull requests or pushes to main branches). These are defined in the `.github/workflows/` directory.
2.  **Local Testing (Docker Containers)**: A suite of on-demand tests that can be run locally by developers without installing any tools on their host machine. These are managed via the `docker-composer-508.yml` file.

---

## 🛠️ How to Use This Project

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed and running on your local machine.
- A code editor like [VS Code](https://code.visualstudio.com/).

### Running Local Tests

All local tests are managed through the `docker-composer-508.yml` file. You can run any of the defined services using the `docker-compose` command.

**1. Start the Web Server**

First, to run most tests, you need the local web server running.

```bash
docker-compose -f docker-composer-508.yml up -d web
```

This will start a PHP Apache server, accessible at `http://localhost:8090`. The `some_file_for_testing.php` will be available at `http://localhost:8090/some_file_for_testing.php`.

**2. Run a Specific Test**

You can run any of the testing containers by specifying the service name.

docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=test backstop

-   **Visual Regression Testing (BackstopJS)**:
    -   To create reference images: `docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=test reference`
    -   To run a test: `docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=test backstop`
    -   Reports are saved in `scripts/visual_regression_backstop/backstop_data/`.
    -   To access the test results, visit the index here: `scripts/visual_regression_backstop/backstop_data/index.html`.

-   **Security Scanning (OWASP ZAP)**:
    -   `docker-compose -f docker-composer-508.yml run --rm zap`.
    -   This now dynamically scans all URLs listed in `scripts/508-test-pages.json`.
    -   HTML reports for each scanned URL will be generated in the `zap-results/` directory.
    -   *Note: This uses the `ghcr.io/zaproxy/zaproxy:stable` image.*

-   **Code Quality (ESLint & PHP_CodeSniffer)**:
    -   `docker-compose -f docker-composer-508.yml run --rm code-quality`
    -   This will run both linters and output the results to the console.

-   **Link Validation (Lychee)**:
    -   `docker-compose -f docker-composer-508.yml run --rm link-checker`
    -   This will scan all URLs found in `scripts/load_test_sitemap.xml` for broken links.

**3. Stop All Services**

When you are finished, you can stop all running containers.

```bash
docker-compose -f docker-composer-508.yml down
```

---

## 🧪 Implemented Tests

This project includes a wide array of automated tests, each configured to demonstrate a specific aspect of a modern testing pipeline.

### Server-Side CI/CD Workflows (GitHub Actions)

-   **Accessibility (Axe-core & Pa11y)**: Two workflows that check for Section 508 and WCAG compliance.
-   **Performance & SEO (Lighthouse CI)**: Measures Core Web Vitals and other best practices.
-   **Security (OWASP ZAP)**: Performs automated vulnerability scanning.
-   **Code Quality (ESLint & PHP_CodeSniffer)**: Enforces coding standards for JavaScript and PHP.
-   **HTML Validation (HTMLHint)**: Checks for valid HTML.
-   **Link Validation (Lychee)**: Finds broken links in documentation.

### Local Testing Containers

-   **Web Server**: A PHP-Apache container to serve the application.
-   **BackstopJS**: For visual regression testing.
-   **OWASP ZAP**: For local security scans.
-   **Code Quality Suite**: A combined container for ESLint and PHP_CodeSniffer.
-   **Lychee**: For local link checking.

## 📂 File Structure Overview

-   `ai_notebook.md`: The central project documentation and development log.
-   `docker-composer-508.yml`: The Docker Compose file for all local testing services.
-   `.github/workflows/`: Contains all GitHub Actions CI/CD workflows.
-   `scripts/`: Home for test configurations and helper scripts.
-   `web/`: The root directory for the application code being tested.
-   `*.json`, `*.rc`: Configuration files for the various linting and testing tools.

---

This project is intended for educational purposes and can be freely adapted. We hope it serves as a valuable resource for your own automation and CI/CD journey!
