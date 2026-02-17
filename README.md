# Keyboard Trackpad for macOS

Turn your Apple keyboard into a trackpad! This macOS app enables a temporary "keyboard trackpad mode" where your keyboard keys map to absolute screen positions.

## Features

- **Trigger Key Activation**: Hold Fn/Globe key (or Control+Option as fallback) to enter trackpad mode
- **Instant Cursor Warp**: Press any key to warp the cursor to its mapped screen region
- **Immediate Exit**: Release the trigger key to exit mode and resume normal typing
- **Multi-Display Support**: Safely handles multiple displays
- **Apple Keyboards Only**: Optimized for Apple keyboard layouts
- **Non-Intrusive**: Normal typing is completely unaffected when not in trackpad mode

## Requirements

- macOS 13.0 or later
- Apple keyboard
- Accessibility permissions (will be prompted on first run)

## Building

This project uses Swift Package Manager:

```bash
# Build the app
swift build -c release

# The executable will be in .build/release/KeyboardTrackpad
```

## Running

```bash
# Run directly
.build/release/KeyboardTrackpad

# Or run with Swift
swift run
```

## Usage

1. Launch the app (you'll see a keyboard icon in the menu bar)
2. Grant Accessibility permissions when prompted (System Preferences > Privacy & Security > Accessibility)
3. Hold the Fn/Globe key (or Control+Option together)
4. While holding, press any key to warp the cursor to that key's mapped position
5. Release to exit trackpad mode and resume normal typing

## How It Works

- **Event Monitoring**: Uses macOS Accessibility APIs to monitor keyboard events
- **Cursor Warping**: Uses Quartz Display Services (`CGDisplayMoveCursorToPoint`) to move the cursor
- **Key Mapping**: Each keyboard key is mapped to a specific screen position based on its layout position
- **Mode Detection**: Trackpad mode is only active while the trigger key is held
- **Multi-Display**: Automatically detects which display should receive the cursor based on target coordinates

## Technical Details

The app consists of:
- `AppDelegate.swift`: Menu bar app lifecycle and permissions handling
- `KeyboardTrackpadMode.swift`: Event monitoring and mode activation logic
- `KeyboardPositionMapper.swift`: Keyboard key to screen position mapping

## Permissions

The app requires:
- **Accessibility**: To monitor keyboard events globally and control the cursor
- The app will prompt for these permissions on first launch

## License

MIT
