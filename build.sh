#!/bin/bash
# Build and validation script for KeyboardTrackpad
# This script must be run on macOS

set -e

echo "Keyboard Trackpad - Build Script"
echo "================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ ERROR: This application can only be built on macOS"
    echo ""
    echo "This is a macOS-only application that uses:"
    echo "  - Cocoa framework (AppKit)"
    echo "  - ApplicationServices framework (Accessibility, Quartz)"
    echo "  - Carbon framework (HIToolbox for key codes)"
    echo ""
    echo "To build this project, please run this script on macOS 13.0 or later."
    exit 1
fi

echo "✓ Running on macOS"
echo ""

# Build the project
echo "Building KeyboardTrackpad..."
swift build -c release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""

    # Create .app bundle
    APP_DIR="KeyboardTrackpad.app"
    echo "Creating app bundle: $APP_DIR"

    rm -rf "$APP_DIR"
    mkdir -p "$APP_DIR/Contents/MacOS"
    cp .build/release/KeyboardTrackpad "$APP_DIR/Contents/MacOS/"
    cp Info.plist "$APP_DIR/Contents/"

    # Ad-hoc codesign the bundle
    codesign --force --sign - "$APP_DIR"

    echo ""
    echo "✅ App bundle created and signed!"
    echo ""
    echo "The app bundle is located at:"
    echo "  $APP_DIR"
    echo ""
    echo "To run the app:"
    echo "  open $APP_DIR"
    echo ""
    echo "Note: You will need to grant Accessibility permissions on first run."
else
    echo ""
    echo "❌ Build failed"
    exit 1
fi
