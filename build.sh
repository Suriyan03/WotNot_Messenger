#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Installing Node.js and Frontend Dependencies ---"

# 1. Install Node.js (required to run npm)
# We assume the Node version required by the Vue project is compatible with what Render provides.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
nvm install 18 # Install a stable LTS version of Node.js

# 2. Build the Vue Frontend Application
# Run npm install and npm run build inside the frontend/my-vue-app directory
cd frontend/my-vue-app
npm install
npm run build

# 3. Move the compiled static assets into the backend's static file location (or root)
# This assumes your backend serves static content from a standard location, 
# or you can adjust your backend config to serve the 'dist' folder.
# For simplicity, we just move the compiled files up.
cd ../..
# Optional: if you need to copy assets, add them here.

echo "--- Installing Python Backend Dependencies ---"
# 4. Install Python Dependencies
pip install -r backend/requirements.txt

echo "--- Build Process Complete ---"
