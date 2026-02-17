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
    echo "The executable is located at:"
    echo "  .build/release/KeyboardTrackpad"
    echo ""
    echo "To run the app:"
    echo "  ./.build/release/KeyboardTrackpad"
    echo ""
    echo "Note: You will need to grant Accessibility permissions on first run."
else
    echo ""
    echo "❌ Build failed"
    exit 1
fi
