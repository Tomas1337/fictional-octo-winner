# Keyboard Trackpad for macOS

Turn your Apple keyboard into a trackpad! This macOS app enables a temporary "keyboard trackpad mode" where your keyboard keys map to absolute screen positions.

## Features

- **Trigger Key Activation**: Hold Fn/Globe key (or Control+Option as fallback) to enter trackpad mode
- **Instant Cursor Warp**: Press any key to warp the cursor to its mapped screen region
- **Immediate Exit**: Release the trigger key to exit mode and resume normal typing
- **Multi-Display Support**: Safely handles multiple displays
- **Apple Keyboards Only**: Optimized for Apple keyboard layouts
- **Non-Intrusive**: Normal typing is completely unaffected when not in trackpad mode

## Quick Start

```bash
# Build (requires macOS)
./build.sh

# Run
.build/release/KeyboardTrackpad
```

Then:
1. Grant Accessibility permissions when prompted
2. Hold Fn/Globe (or Control+Option)
3. Press any key to warp cursor to that position
4. Release to exit mode

## Documentation

- **[USAGE.md](USAGE.md)** - Detailed usage guide with examples and tips
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture and design
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development guide for contributors

## Requirements

- macOS 13.0 or later
- Apple keyboard
- Accessibility permissions (will be prompted on first run)

## How It Works

The app monitors your keyboard using macOS Accessibility APIs. When you hold the trigger key (Fn/Globe or Control+Option), it enters "trackpad mode." In this mode, each key on your keyboard corresponds to a specific screen position. Press a key, and the cursor instantly warps to that position using Quartz Display Services.

### Key Mapping Example

```
Screen Layout:
┌─────────────────────────────────┐
│ 1  2  3  4  5  6  7  8  9  0    │  ← Numbers → Top of screen
│                                 │
│ Q  W  E  R  T  Y  U  I  O  P    │  ← QWERTY → Upper area
│                                 │
│ A  S  D  F  G  H  J  K  L  ;    │  ← ASDF → Middle area
│                                 │
│ Z  X  C  V  B  N  M  ,  .  /    │  ← ZXCV → Lower area
│                                 │
│        SPACE (center)           │  ← Space → Bottom
└─────────────────────────────────┘
```

## Building from Source

This project uses Swift Package Manager:

```bash
# Build the app
swift build -c release

# The executable will be in .build/release/KeyboardTrackpad
```

## Usage

1. Launch the app (you'll see a keyboard icon in the menu bar)
2. Grant Accessibility permissions when prompted (System Settings > Privacy & Security > Accessibility)
3. Hold the Fn/Globe key (or Control+Option together)
4. While holding, press any key to warp the cursor to that key's mapped position
5. Release to exit trackpad mode and resume normal typing

## Technical Details

The app consists of:
- **AppDelegate.swift**: Menu bar app lifecycle and permissions handling
- **KeyboardTrackpadMode.swift**: Event monitoring and mode activation logic
- **KeyboardPositionMapper.swift**: Keyboard key to screen position mapping

### APIs Used
- **Accessibility API**: For global keyboard event monitoring
- **Quartz Display Services**: For cursor warping (`CGDisplayMoveCursorToPoint`)
- **Carbon HIToolbox**: For keyboard key code constants
- **AppKit (Cocoa)**: For menu bar UI and app lifecycle

## Multi-Display Support

The app automatically detects all connected displays and distributes the keyboard mapping across the combined screen space. When you press a key, the cursor warps to the correct display based on the target position.

## Permissions

The app requires:
- **Accessibility**: To monitor keyboard events globally and control the cursor position

The app will prompt for these permissions on first launch and guide you to System Settings if needed.

## Privacy & Security

- No keyboard data is logged, stored, or transmitted
- Only monitors modifier keys and key codes (not typed characters)
- All processing is completely local - no network access
- Open source - review the code yourself!

## Limitations

- **macOS only**: Requires macOS 13.0 or later
- **Apple keyboards**: Optimized for Apple keyboard layouts
- **No click simulation**: Only moves cursor, doesn't perform clicks
- **No continuous motion**: Cursor warps instantly (by design)
- **Requires accessibility**: Must grant system permissions

## Troubleshooting

### Cursor not moving?
- Ensure you're holding the trigger key (Fn/Globe or Control+Option)
- Check that Accessibility permissions are granted
- Restart the app if you recently connected/disconnected displays

### Keys still typing in trackpad mode?
This is expected behavior. The app observes key events but doesn't suppress them. Consider using the feature when no text field is focused.

## Contributing

Contributions are welcome! Please see [DEVELOPMENT.md](DEVELOPMENT.md) for development setup, code structure, and guidelines.

## License

MIT License - see LICENSE file for details

## Acknowledgments

This project implements a unique approach to keyboard-based cursor control using macOS native APIs, inspired by the need for quick cursor positioning without traditional pointing devices.
