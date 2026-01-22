#!/bin/bash
# launch_app.sh - Build and launch the IVF Dashboard using PM2
set -e

# Configuration
APP_NAME="ivf-dashboard"
PORT=8080
# Get the absolute path to the project root (parent of scripts directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_DIR="$PROJECT_ROOT/app"
BUILD_DIR="$APP_DIR/build/web"

echo "--- Launching $APP_NAME on Port $PORT ---"

# 1. Prepare Flutter
echo "Building Flutter Web App..."
cd "$APP_DIR"

if ! command -v flutter &> /dev/null; then
    # Try to find flutter in home if not in path
    if [ -d "$HOME/flutter/bin" ]; then
        export PATH="$PATH:$HOME/flutter/bin"
    fi
fi

flutter pub get
flutter build web --release --web-renderer auto

# 2. Setup PM2
echo "Managing PM2 Process..."

# Navigate back to scripts dir for PM2 context if needed
cd "$SCRIPT_DIR"

# Check if process is already running
if pm2 list | grep -q "$APP_NAME"; then
    echo "Restarting existing PM2 process..."
    pm2 restart "$APP_NAME"
else
    echo "Starting new PM2 process..."
    # 'serve -s' is used for Single Page Applications (SPA) to handle routing
    pm2 start "serve -s $BUILD_DIR -p $PORT" --name "$APP_NAME"
fi

# 3. Save PM2 state for persistence after reboot
echo "Enabling PM2 persistence..."
pm2 save

# Setup PM2 startup script if not already done
# Note: This might require sudo on some systems
# pm2 startup

echo "----------------------------------------------------"
echo "Application launched successfully!"
echo "Name: $APP_NAME"
echo "Process: $(pm2 list | grep $APP_NAME)"
echo "App is serving from: $BUILD_DIR"
echo "----------------------------------------------------"
pm2 status
