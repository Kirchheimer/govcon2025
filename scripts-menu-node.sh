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
    echo -e "${YELLOW}Installing All Dependencies for Debian Server${NC}"
    echo ""
    
    # Check if running as root or with sudo access
    if [[ $EUID -eq 0 ]]; then
        SUDO=""
    else
        SUDO="sudo"
        echo -e "${BLUE}Note: This script will use sudo for system-level installations${NC}"
        echo ""
    fi
    
    # System updates and basic tools - Critical for old containers
    echo -e "${GREEN}Step 1: Updating system packages (critical for old containers)...${NC}"
    echo -e "${BLUE}This may take a few minutes on old containers...${NC}"
    
    # First, try to fix any broken packages from old containers
    $SUDO apt-get --fix-broken install -y 2>/dev/null || true
    
    # Update package lists with retry logic for old containers
    echo -e "${BLUE}Updating package lists...${NC}"
    for i in {1..3}; do
        if $SUDO apt-get update; then
            echo -e "${GREEN}Package lists updated successfully${NC}"
            break
        else
            echo -e "${YELLOW}Update attempt $i failed, retrying...${NC}"
            if [ $i -eq 3 ]; then
                echo -e "${RED}Failed to update package lists after 3 attempts.${NC}"
                echo -e "${RED}This is common with very old containers. Continuing anyway...${NC}"
                echo -e "${YELLOW}Some packages may fail to install, but basic functionality should work.${NC}"
            fi
            sleep 2
        fi
    done
    
    # Upgrade existing packages to avoid conflicts
    echo -e "${BLUE}Upgrading existing packages to avoid conflicts...${NC}"
    $SUDO apt-get upgrade -y || {
        echo -e "${YELLOW}Package upgrade had issues, but continuing...${NC}"
    }
    
    echo -e "${GREEN}Step 2: Installing essential development tools...${NC}"
    $SUDO apt-get install -y curl wget git build-essential jq unzip htop tree || {
        echo -e "${YELLOW}Some essential tools failed to install. Continuing...${NC}"
    }
    
    # Node.js and npm installation
    echo -e "${GREEN}Step 3: Installing Node.js and npm...${NC}"
    if ! command -v node &> /dev/null; then
        $SUDO apt-get install -y nodejs npm || {
            echo -e "${RED}Failed to install Node.js. Trying alternative method...${NC}"
            # Alternative: Install Node.js from NodeSource repository
            curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO -E bash -
            $SUDO apt-get install -y nodejs
        }
    else
        echo -e "${BLUE}Node.js already installed: $(node -v)${NC}"
    fi
    
    # Verify npm and install npx if needed
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}npm not found. Please install Node.js manually.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${GREEN}Step 4: Installing global Node.js tools...${NC}"
    # Install yarn as an alternative package manager
    if ! command -v yarn &> /dev/null; then
        npm install -g yarn || echo -e "${YELLOW}Failed to install yarn globally${NC}"
    fi
    
    # Install Lighthouse CI
    npm install -g @lhci/cli@0.12.x || echo -e "${YELLOW}Failed to install Lighthouse CI globally${NC}"
    
    # PHP and related tools for code quality testing
    echo -e "${GREEN}Step 5: Installing PHP and development tools...${NC}"
    if ! command -v php &> /dev/null; then
        $SUDO apt-get install -y php php-cli php-mbstring php-xml php-curl php-zip || {
            echo -e "${YELLOW}PHP installation failed. Some tests may not work.${NC}"
        }
    else
        echo -e "${BLUE}PHP already installed: $(php -v | head -n1)${NC}"
    fi
    
    # Install Composer for PHP dependency management
    if ! command -v composer &> /dev/null; then
        echo -e "${GREEN}Installing Composer...${NC}"
        curl -sS https://getcomposer.org/installer | php
        $SUDO mv composer.phar /usr/local/bin/composer
        $SUDO chmod +x /usr/local/bin/composer
    else
        echo -e "${BLUE}Composer already installed${NC}"
    fi
    
    # Install PHP_CodeSniffer via Composer
    echo -e "${GREEN}Step 6: Installing PHP_CodeSniffer...${NC}"
    if ! command -v phpcs &> /dev/null; then
        composer global require squizlabs/php_codesniffer || {
            echo -e "${YELLOW}Failed to install PHP_CodeSniffer globally${NC}"
        }
        # Add composer global bin to PATH if not already there
        echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.composer/vendor/bin:$PATH"
    else
        echo -e "${BLUE}PHP_CodeSniffer already installed${NC}"
    fi
    
    # Install project-specific Node.js dependencies
    echo -e "${GREEN}Step 7: Installing project Node.js dependencies...${NC}"
    npm install axe-core puppeteer eslint htmlhint || {
        echo -e "${YELLOW}Some Node.js dependencies failed to install${NC}"
    }
    
    # Install additional useful tools
    echo -e "${GREEN}Step 8: Installing additional testing tools...${NC}"
    
    # Try to install Lychee link checker
    if ! command -v lychee &> /dev/null; then
        echo -e "${BLUE}Attempting to install Lychee link checker...${NC}"
        # Try to install via cargo if available
        if command -v cargo &> /dev/null; then
            cargo install lychee || echo -e "${YELLOW}Failed to install lychee via cargo${NC}"
        else
            echo -e "${YELLOW}Cargo not available. Installing Rust and Cargo...${NC}"
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source ~/.cargo/env
            cargo install lychee || echo -e "${YELLOW}Failed to install lychee${NC}"
        fi
    else
        echo -e "${BLUE}Lychee already installed${NC}"
    fi
    
    # Docker installation (useful for containerized testing)
    echo -e "${GREEN}Step 9: Checking Docker installation...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${BLUE}Installing Docker...${NC}"
        $SUDO apt-get install -y docker.io docker-compose || {
            echo -e "${YELLOW}Docker installation failed. You can install it manually later.${NC}"
        }
        # Add user to docker group
        $SUDO usermod -aG docker $USER || echo -e "${YELLOW}Failed to add user to docker group${NC}"
    else
        echo -e "${BLUE}Docker already installed: $(docker --version)${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}=== Installation Summary ===${NC}"
    echo -e "${GREEN}✓ System packages updated${NC}"
    echo -e "${GREEN}✓ Essential development tools installed${NC}"
    echo -e "${GREEN}✓ Node.js and npm: $(node -v 2>/dev/null || echo 'Not available') / $(npm -v 2>/dev/null || echo 'Not available')${NC}"
    echo -e "${GREEN}✓ PHP: $(php -v 2>/dev/null | head -n1 || echo 'Not available')${NC}"
    echo -e "${GREEN}✓ Composer: $(composer --version 2>/dev/null || echo 'Not available')${NC}"
    echo -e "${GREEN}✓ Docker: $(docker --version 2>/dev/null || echo 'Not available')${NC}"
    echo ""
    
    echo -e "${YELLOW}Additional tools that may need manual installation:${NC}"
    echo "- OWASP ZAP: https://www.zaproxy.org/"
    echo "- Browser for testing (if running headless): chromium-browser"
    echo ""
    
    echo -e "${BLUE}Note: You may need to restart your terminal or run 'source ~/.bashrc' to update your PATH${NC}"
    echo -e "${BLUE}Note: If Docker was just installed, you may need to log out and back in for group permissions${NC}"
    
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
