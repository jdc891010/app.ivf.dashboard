#!/bin/bash
# install_requirements.sh - Install dependencies for IVF Dashboard on Linux (Cloudways)
set -e

echo "--- Starting Requirements Installation for Linux ---"

# 1. Update system packages
echo "Updating system packages..."
# Cloudways might not require sudo or might have specific restrictions, but these are standard
sudo apt-get update -y
sudo apt-get install -y curl git unzip xz-utils libglu1-mesa

# 2. Install NVM and Node.js
if [ -z "$NVM_DIR" ]; then
    echo "Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Load NVM if it was just installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing Node.js (LTS)..."
nvm install --lts
nvm use --lts

# 3. Install PM2 and Serve globally
echo "Installing PM2 and 'serve' package..."
npm install -g pm2 serve

# 4. Install Flutter SDK
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter SDK..."
    cd $HOME
    if [ ! -d "flutter" ]; then
        git clone https://github.com/flutter/flutter.git -b stable
    fi
    
    # Export path for current session
    export PATH="$PATH:$HOME/flutter/bin"
    
    # Add to .bashrc for future sessions
    if ! grep -q "flutter/bin" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    fi
    
    echo "Initializing Flutter..."
    $HOME/flutter/bin/flutter precache
    $HOME/flutter/bin/flutter doctor
else
    echo "Flutter is already installed."
fi

echo "----------------------------------------------------"
echo "Installation Complete!"
echo "IMPORTANT: Run 'source ~/.bashrc' to update your current shell."
echo "Then you can run ./launch_app.sh to start the application."
echo "----------------------------------------------------"
