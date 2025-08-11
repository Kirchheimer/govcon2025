#!/bin/bash

# Navigate to the Node.js service directory
cd /app

# Install dependencies
echo "Installing dependencies..."
npm install axe-core puppeteer

# Run the accessibility check script
echo "Running accessibility checks..."
node scripts/accessibility/axe-test.js
echo "Accessibility checks completed."