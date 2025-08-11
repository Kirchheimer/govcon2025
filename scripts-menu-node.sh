#!/bin/bash

# GovCon 2025 Testing Suite Menu - Node.js Version
# Runs commands directly from GitHub workflows without Docker

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
    echo -e "${BLUE}   GovCon 2025 - Testing Suite Menu (Node.js)  ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

# Function to check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Error: Node.js is not installed. Please install Node.js first.${NC}"
        echo "Visit: https://nodejs.org/"
        exit 1
    fi
    
    node_version=$(node -v)
    echo -e "${GREEN}Node.js ${node_version} detected${NC}"
    echo ""
}

# Function to display main menu
display_main_menu() {
    echo "Select a test suite to run:"
    echo ""
    echo "1: Accessibility Testing (Axe-core)"
    echo "2: Performance & SEO Testing (Lighthouse CI)"
    echo "3: Code Quality - JavaScript (ESLint)"
    echo "4: Code Quality - PHP (PHP_CodeSniffer)"
    echo "5: HTML Validation (HTMLHint)"
    echo "6: Link Validation (Lychee)"
    echo "7: Security Scanning (OWASP ZAP)"
    echo "8: Install All Dependencies"
    echo "9: Exit"
    echo ""
}

# Function to run Axe-core accessibility tests
run_axe_accessibility() {
    echo -e "${YELLOW}Accessibility Testing (Axe-core)${NC}"
    echo "Tests for Section 508 and WCAG compliance"
    echo ""
    
    # Check if dependencies are installed
    if [ ! -d "node_modules/axe-core" ] || [ ! -d "node_modules/puppeteer" ]; then
        echo -e "${YELLOW}Installing required dependencies...${NC}"
        npm install axe-core puppeteer
    fi
    
    echo -e "${GREEN}Running accessibility tests...${NC}"
    node scripts/accessibility/axe_test.js
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run Lighthouse CI
run_lighthouse() {
    echo -e "${YELLOW}Performance & SEO Testing (Lighthouse CI)${NC}"
    echo "Analyzes performance, accessibility, best practices, and SEO"
    echo ""
    
    # Check if Lighthouse CI is installed globally
    if ! command -v lhci &> /dev/null; then
        echo -e "${YELLOW}Installing Lighthouse CI globally...${NC}"
        npm install -g @lhci/cli@0.12.x
    fi
    
    # Create Lighthouse config
    echo -e "${GREEN}Creating Lighthouse configuration...${NC}"
    cat > lighthouserc.js << 'EOF'
module.exports = {
  ci: {
    collect: {
      url: [
        'https://about.google/',
        'https://blog.google/inside-google/doodles/',
        'https://blog.google/outreach-initiatives/public-policy/'
      ],
      settings: {
        chromeFlags: '--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage'
      }
    },
    assert: {
      assertions: {
        'categories:performance': ['warn', {minScore: 0.7}],
        'categories:accessibility': ['error', {minScore: 0.9}],
        'categories:best-practices': ['warn', {minScore: 0.8}],
        'categories:seo': ['warn', {minScore: 0.8}],
        'categories:pwa': 'off'
      }
    },
    upload: {
      target: 'temporary-public-storage'
    }
  }
};
EOF
    
    echo -e "${GREEN}Running Lighthouse CI...${NC}"
    lhci autorun --config=lighthouserc.js
    
    echo -e "${GREEN}Lighthouse reports generated in .lighthouseci/ directory${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run ESLint
run_eslint() {
    echo -e "${YELLOW}JavaScript Code Quality (ESLint)${NC}"
    echo "Checks JavaScript code against coding standards"
    echo ""
    
    # Check if ESLint is installed
    if [ ! -d "node_modules/eslint" ]; then
        echo -e "${YELLOW}Installing ESLint...${NC}"
        npm install eslint
    fi
    
    echo -e "${GREEN}Running ESLint...${NC}"
    npx eslint . --ext .js,.jsx,.ts,.tsx || true
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run PHP_CodeSniffer
run_phpcs() {
    echo -e "${YELLOW}PHP Code Quality (PHP_CodeSniffer)${NC}"
    echo "Checks PHP code against PSR-12 standards"
    echo ""
    
    # Check if PHP is installed
    if ! command -v php &> /dev/null; then
        echo -e "${RED}PHP is not installed. Please install PHP first.${NC}"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    # Check if phpcs is installed
    if ! command -v phpcs &> /dev/null; then
        echo -e "${YELLOW}Installing PHP_CodeSniffer...${NC}"
        echo "You may need to install it globally with:"
        echo "composer global require squizlabs/php_codesniffer"
        echo "or"
        echo "pear install PHP_CodeSniffer"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}Running PHP_CodeSniffer...${NC}"
    phpcs --standard=PSR12 web/ || true
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run HTMLHint
run_htmlhint() {
    echo -e "${YELLOW}HTML Validation (HTMLHint)${NC}"
    echo "Validates HTML files for errors and best practices"
    echo ""
    
    # Check if HTMLHint is installed
    if [ ! -d "node_modules/htmlhint" ]; then
        echo -e "${YELLOW}Installing HTMLHint...${NC}"
        npm install htmlhint
    fi
    
    echo -e "${GREEN}Running HTMLHint...${NC}"
    npx htmlhint "**/*.html" --config .htmlhintrc || true
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run Lychee link checker
run_lychee() {
    echo -e "${YELLOW}Link Validation (Lychee)${NC}"
    echo "Checks for broken links in documentation"
    echo ""
    
    # Check if lychee is installed
    if ! command -v lychee &> /dev/null; then
        echo -e "${YELLOW}Lychee is not installed.${NC}"
        echo "Install it with one of these methods:"
        echo "- macOS: brew install lychee"
        echo "- Download from: https://github.com/lycheeverse/lychee/releases"
        echo "- Cargo: cargo install lychee"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}Running Lychee link checker...${NC}"
    lychee --verbose --no-progress README.md scripts/**/*.md .github/**/*.md || true
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to run OWASP ZAP
run_zap() {
    echo -e "${YELLOW}Security Scanning (OWASP ZAP)${NC}"
    echo "Note: This requires OWASP ZAP to be installed locally"
    echo ""
    echo "For the Node.js version, you have several options:"
    echo ""
    echo "1. Use the Docker version from the main menu (recommended)"
    echo "2. Install OWASP ZAP locally from: https://www.zaproxy.org/download/"
    echo "3. Use the ZAP API if you have ZAP running"
    echo ""
    
    if command -v zap-cli &> /dev/null; then
        echo -e "${GREEN}ZAP CLI detected. Running baseline scan...${NC}"
        # Read URLs from JSON file
        urls=$(cat scripts/508-test-pages.json | jq -r '.[]' 2>/dev/null || echo "https://about.google/")
        
        for url in $urls; do
            echo "Scanning: $url"
            zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' "$url" || true
        done
    else
        echo -e "${YELLOW}ZAP CLI not found. Please install OWASP ZAP or use the Docker version.${NC}"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to install all dependencies
install_all_dependencies() {
    echo -e "${YELLOW}Installing All Dependencies${NC}"
    echo ""
    
    echo -e "${GREEN}Installing Node.js dependencies...${NC}"
    npm install axe-core puppeteer eslint htmlhint
    
    echo -e "${GREEN}Installing global tools...${NC}"
    npm install -g @lhci/cli@0.12.x
    
    echo ""
    echo -e "${YELLOW}Additional tools that need manual installation:${NC}"
    echo "- PHP & PHP_CodeSniffer: https://www.php.net/ & composer/pear"
    echo "- Lychee: https://github.com/lycheeverse/lychee"
    echo "- OWASP ZAP: https://www.zaproxy.org/"
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to show GitHub Actions info
show_github_info() {
    echo -e "${BLUE}GitHub Actions Workflow Information${NC}"
    echo ""
    echo "This menu runs the same commands used in GitHub Actions workflows."
    echo ""
    echo "To trigger GitHub Actions workflows, push to these branches:"
    echo "- Accessibility (Axe): testbot/508-test-run"
    echo "- Accessibility (Pa11y): testbot/508-pa11y-test-run"
    echo "- Lighthouse CI: testbot/lighthouse-test-run"
    echo "- ESLint: testbot/eslint-test-run"
    echo "- PHP_CodeSniffer: testbot/phpcs-test-run"
    echo "- HTMLHint: testbot/htmlhint-test-run"
    echo "- Link Checker: testbot/linkchecker-test-run"
    echo "- OWASP ZAP: testbot/security-test-run"
    echo ""
}

# Main script execution
check_node

while true; do
    display_header
    show_github_info
    display_main_menu
    
    read -p "Enter choice [1-9]: " choice
    
    case $choice in
        1)
            display_header
            run_axe_accessibility
            ;;
        2)
            display_header
            run_lighthouse
            ;;
        3)
            display_header
            run_eslint
            ;;
        4)
            display_header
            run_phpcs
            ;;
        5)
            display_header
            run_htmlhint
            ;;
        6)
            display_header
            run_lychee
            ;;
        7)
            display_header
            run_zap
            ;;
        8)
            display_header
            install_all_dependencies
            ;;
        9)
            echo -e "${GREEN}Thank you for using GovCon 2025 Testing Suite!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
