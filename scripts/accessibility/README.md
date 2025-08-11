# Accessibility Scripts

This directory holds the scripts used for running automated accessibility tests.

## Files

-   **`axe_test.js`**: This is a Node.js script that uses Puppeteer and Axe-core to perform accessibility testing. It navigates to a list of URLs, injects the Axe-core library, and generates a report of any violations found. The script is designed to be run from the command line and is used by the `accessibility-axe.yml` GitHub Actions workflow.

-   **`run_access_check.sh`**: An empty shell script intended for future expansion, such as running a sequence of accessibility tests or generating combined reports.
