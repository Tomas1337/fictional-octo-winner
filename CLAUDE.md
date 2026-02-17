# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KeyboardTrackpad is a macOS menu bar application (macOS 13.0+) that transforms an Apple keyboard into a trackpad. Hold Fn/Globe key (or Control+Option) to enter "trackpad mode" where each key warps the cursor to a grid-mapped screen position. Pure Swift 5.9+ with no external dependencies.

## Build Commands

```bash
# Debug build
swift build

# Release build
swift build -c release

# Run (debug)
.build/debug/KeyboardTrackpad

# Run (release)
.build/release/KeyboardTrackpad

# Build script (includes platform validation)
./build.sh
```

There are no automated tests — the app requires macOS Accessibility permissions and system-level access, making CI testing impractical. Testing is manual.

## Architecture

Four source files in `Sources/KeyboardTrackpad/`:

- **main.swift** — Entry point. Creates NSApplication, sets delegate, runs event loop.
- **AppDelegate.swift** — Menu bar setup (NSStatusBar), accessibility permission prompting (AXIsProcessTrustedWithOptions), lifecycle management.
- **KeyboardTrackpadMode.swift** — Core logic. Installs global+local NSEvent monitors for `.flagsChanged` and `.keyDown`. Detects Fn or Control+Option to toggle trackpad mode. Calls `CGDisplayMoveCursorToPoint()` for instant cursor warping with multi-display support via `CGGetActiveDisplayList()`.
- **KeyboardPositionMapper.swift** — Maps ~60 virtual key codes (Carbon.HIToolbox) to proportional screen positions on a 6-row grid. Screen bounds recalculated on each keypress to handle display changes dynamically.

Key frameworks: Cocoa (AppKit), ApplicationServices (Quartz/CoreGraphics), Carbon.HIToolbox (virtual key codes).

The app runs as `LSUIElement: true` (menu bar only, no Dock icon).
