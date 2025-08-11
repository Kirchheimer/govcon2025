#!/bin/bash

# GovCon 2025 Testing Suite Menu
# Educational automation testing suite for government contractors

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the header
display_header() {
    clear
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}       GovCon 2025 - Testing Suite Menu         ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}Error: Docker is not running. Please start Docker first.${NC}"
        exit 1
    fi
}

# Function to display main menu
display_main_menu() {
    echo "Select a test suite to run:"
    echo ""
    echo "1: Visual Regression Testing (BackstopJS)"
    echo "2: Security Scanning (OWASP ZAP)"
    echo "3: Code Quality Testing (ESLint & PHP_CodeSniffer)"
    echo "4: Link Validation (Lychee)"
    echo "5: Accessibility Testing (Axe-core)"
    echo "6: Service Management (Web Server)"
    echo "7: View Test Reports"
    echo "8: Exit"
    echo ""
}

# Function to run BackstopJS tests
run_backstop() {
    echo -e "${YELLOW}BackstopJS Visual Regression Testing${NC}"
    echo "This tool captures screenshots and compares them against baseline images."
    echo ""
    echo "1: Create reference images (first time setup)"
    echo "2: Run visual regression tests"
    echo "3: Approve changes (update reference images)"
    echo "4: Back to main menu"
    echo ""
    
    read -p "Select an option [1-4]: " backstop_choice
    
    case $backstop_choice in
        1)
            echo -e "${GREEN}Creating reference images...${NC}"
            docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=reference backstop
            echo -e "${GREEN}Reference images created successfully!${NC}"
            ;;
        2)
            echo -e "${GREEN}Running visual regression tests...${NC}"
            docker-compose -f docker-composer-508.yml run --rm backstop
            echo -e "${GREEN}Tests complete! View report at: scripts/visual_regression_backstop/backstop_data/html_report/index.html${NC}"
            ;;
        3)
            echo -e "${YELLOW}Approving changes will update all reference images.${NC}"
            read -p "Are you sure you want to approve all changes? (y/n): " confirm
            if [[ $confirm == "y" || $confirm == "Y" ]]; then
                docker-compose -f docker-composer-508.yml run --rm -e BACKSTOP_COMMAND=approve backstop
                echo -e "${GREEN}Reference images updated!${NC}"
            else
                echo "Approval cancelled."
            fi
            ;;
        4)
            return
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run security scanning
run_security_scan() {
    echo -e "${YELLOW}OWASP ZAP Security Scanning${NC}"
    echo "This tool scans URLs for security vulnerabilities."
    echo ""
    echo -e "${GREEN}Starting security scan on all URLs from scripts/508-test-pages.json...${NC}"
    
    docker-compose -f docker-composer-508.yml run --rm zap
    
    echo -e "${GREEN}Security scan complete!${NC}"
    echo "Reports saved in: zap-results/"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run code quality tests
run_code_quality() {
    echo -e "${YELLOW}Code Quality Testing${NC}"
    echo "Check code against coding standards and best practices."
    echo ""
    echo "1: Run PHP_CodeSniffer (PSR-12 standard)"
    echo "2: Run ESLint (JavaScript linting)"
    echo "3: Run both PHP_CodeSniffer and ESLint"
    echo "4: Back to main menu"
    echo ""
    
    read -p "Select an option [1-4]: " quality_choice
    
    case $quality_choice in
        1)
            echo -e "${GREEN}Running PHP_CodeSniffer...${NC}"
            docker-compose -f docker-composer-508.yml run --rm code-quality bash -c "pear install PHP_CodeSniffer && phpcs --standard=PSR12 web/"
            ;;
        2)
            echo -e "${GREEN}Running ESLint...${NC}"
            docker-compose -f docker-composer-508.yml run --rm code-quality bash -c "npm install eslint && npx eslint . --ext .js,.jsx,.ts,.tsx"
            ;;
        3)
            echo -e "${GREEN}Running both PHP_CodeSniffer and ESLint...${NC}"
            docker-compose -f docker-composer-508.yml run --rm code-quality
            ;;
        4)
            return
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run link validation
run_link_validation() {
    echo -e "${YELLOW}Link Validation (Lychee)${NC}"
    echo "This tool checks for broken links in the project."
    echo ""
    echo -e "${GREEN}Checking links in scripts/load_test_sitemap.xml...${NC}"
    
    docker-compose -f docker-composer-508.yml run --rm link-checker
    
    echo -e "${GREEN}Link validation complete!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run accessibility tests
run_accessibility() {
    echo -e "${YELLOW}Accessibility Testing (Axe-core)${NC}"
    echo "Test for Section 508 and WCAG compliance."
    echo ""
    echo "1: Run local accessibility test (requires Node.js)"
    echo "2: View GitHub Actions workflow instructions"
    echo "3: Back to main menu"
    echo ""
    
    read -p "Select an option [1-3]: " access_choice
    
    case $access_choice in
        1)
            if command -v node &> /dev/null; then
                echo -e "${GREEN}Running accessibility tests...${NC}"
                node scripts/accessibility/axe_test.js
            else
                echo -e "${RED}Node.js is not installed. Please install Node.js to run local tests.${NC}"
                echo "Alternatively, push to branch 'testbot/508-test-run' to run in GitHub Actions."
            fi
            ;;
        2)
            echo -e "${BLUE}GitHub Actions Accessibility Testing:${NC}"
            echo ""
            echo "1. Axe-core workflow: Push to branch 'testbot/508-test-run'"
            echo "2. Pa11y workflow: Push to branch 'testbot/508-pa11y-test-run'"
            echo ""
            echo "The workflows will run automatically and results will appear in GitHub Actions."
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to manage services
manage_services() {
    echo -e "${YELLOW}Service Management${NC}"
    echo ""
    echo "1: Start web server (port 8090)"
    echo "2: Stop all services"
    echo "3: View running services"
    echo "4: Back to main menu"
    echo ""
    
    read -p "Select an option [1-4]: " service_choice
    
    case $service_choice in
        1)
            echo -e "${GREEN}Starting web server...${NC}"
            docker-compose -f docker-composer-508.yml up -d web
            echo -e "${GREEN}Web server started at http://localhost:8090${NC}"
            ;;
        2)
            echo -e "${YELLOW}Stopping all services...${NC}"
            docker-compose -f docker-composer-508.yml down
            echo -e "${GREEN}All services stopped.${NC}"
            ;;
        3)
            echo -e "${BLUE}Running services:${NC}"
            docker-compose -f docker-composer-508.yml ps
            ;;
        4)
            return
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to view test reports
view_reports() {
    echo -e "${YELLOW}Test Reports${NC}"
    echo ""
    echo "Available reports:"
    echo ""
    
    # Check for BackstopJS report
    if [ -f "scripts/visual_regression_backstop/backstop_data/html_report/index.html" ]; then
        echo -e "${GREEN}✓${NC} BackstopJS Report: scripts/visual_regression_backstop/backstop_data/html_report/index.html"
    else
        echo -e "${RED}✗${NC} BackstopJS Report: Not found (run tests first)"
    fi
    
    # Check for ZAP reports
    if [ -d "zap-results" ] && [ "$(ls -A zap-results/*.html 2>/dev/null)" ]; then
        echo -e "${GREEN}✓${NC} Security Reports: zap-results/"
        ls -1 zap-results/*.html 2>/dev/null | sed 's/^/    - /'
    else
        echo -e "${RED}✗${NC} Security Reports: Not found (run security scan first)"
    fi
    
    echo ""
    echo "1: Open BackstopJS report in browser"
    echo "2: List all report files"
    echo "3: Back to main menu"
    echo ""
    
    read -p "Select an option [1-3]: " report_choice
    
    case $report_choice in
        1)
            if [ -f "scripts/visual_regression_backstop/backstop_data/html_report/index.html" ]; then
                echo -e "${GREEN}Opening BackstopJS report...${NC}"
                open "scripts/visual_regression_backstop/backstop_data/html_report/index.html" 2>/dev/null || \
                xdg-open "scripts/visual_regression_backstop/backstop_data/html_report/index.html" 2>/dev/null || \
                echo -e "${YELLOW}Please open manually: scripts/visual_regression_backstop/backstop_data/html_report/index.html${NC}"
            else
                echo -e "${RED}BackstopJS report not found. Run visual regression tests first.${NC}"
            fi
            ;;
        2)
            echo -e "${BLUE}All report files:${NC}"
            find . -name "*.html" -path "*/report*" -o -path "*/html_report*" | grep -v node_modules
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main script execution
check_docker

while true; do
    display_header
    display_main_menu
    
    read -p "Enter choice [1-8]: " choice
    
    case $choice in
        1)
            display_header
            run_backstop
            ;;
        2)
            display_header
            run_security_scan
            ;;
        3)
            display_header
            run_code_quality
            ;;
        4)
            display_header
            run_link_validation
            ;;
        5)
            display_header
            run_accessibility
            ;;
        6)
            display_header
            manage_services
            ;;
        7)
            display_header
            view_reports
            ;;
        8)
            echo -e "${GREEN}Thank you for using GovCon 2025 Testing Suite!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
