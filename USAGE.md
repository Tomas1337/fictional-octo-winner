# Usage Guide

## Quick Start

1. **Build the application** (on macOS):
   ```bash
   ./build.sh
   ```

2. **Run the application**:
   ```bash
   .build/release/KeyboardTrackpad
   ```

3. **Grant Accessibility Permissions**:
   - When prompted, click "Open System Preferences"
   - Navigate to Privacy & Security > Accessibility
   - Enable the checkbox next to KeyboardTrackpad

4. **Use the feature**:
   - Hold down Fn/Globe key (or Control+Option together)
   - Press any letter key to move cursor to that key's screen position
   - Release Fn/Globe to exit trackpad mode

## Understanding the Key Mapping

The keyboard is mapped to your screen as follows:

### Horizontal Layout
- **Left side keys** (Q, A, Z) → Left side of screen
- **Center keys** (T, G, V, Space) → Center of screen  
- **Right side keys** (P, ;, /) → Right side of screen

### Vertical Layout
- **Top row** (numbers, 1-0) → Top of screen
- **QWERTY row** → Upper-middle of screen
- **ASDF row** → Middle of screen
- **ZXCV row** → Lower-middle of screen
- **Space bar row** → Bottom of screen

### Example Positions

```
Screen:
┌──────────────────────────────────────┐
│  1    2    3    4    5    6    7     │  ← Number row
│                                      │
│  Q    W    E    R    T    Y    U     │  ← Top letter row
│                                      │
│  A    S    D    F    G    H    J     │  ← Home row
│                                      │
│  Z    X    C    V    B    N    M     │  ← Bottom letter row
│                                      │
│         Space (center bottom)        │  ← Space bar
└──────────────────────────────────────┘
```

## Multi-Display Support

When using multiple displays:

1. The key mapping extends across all displays
2. Keys are distributed proportionally across the combined screen space
3. The cursor will warp to the correct display automatically
4. Edge keys reach the outer edges of your multi-display setup

### Example: Two Displays Side-by-Side

```
┌─────────────────┬─────────────────┐
│  Display 1      │  Display 2      │
│  Left keys      │  Right keys     │
│  (Q, A, Z)      │  (P, ;, /)      │
└─────────────────┴─────────────────┘
```

## Trigger Key Options

### Primary: Fn/Globe Key
- **Location**: Bottom left on Apple keyboards (on newer keyboards, marked with 🌐)
- **Advantage**: Single key activation
- **Limitation**: Some keyboards may not report Fn key events

### Fallback: Control + Option
- **Location**: Both are modifier keys near the space bar
- **Advantage**: Works on all keyboards
- **Usage**: Hold both keys simultaneously to activate

The app defaults to accepting either trigger method for maximum compatibility.

## Tips and Tricks

### Precision Navigation
- **Corner access**: Use corner keys (Esc, Delete, /, arrows) for screen corners
- **Center click**: Press G or H (home row center) to reach screen center
- **Quick jumps**: Number keys for quick access to top edge

### Workflow Integration
1. Use trackpad mode to quickly position cursor near target
2. Release trigger to resume normal typing
3. Fine-tune with regular trackpad/mouse
4. Re-enter mode for next jump

### Common Patterns
- **Top-left corner**: Press 1 or Q
- **Top-right corner**: Press 0 or P
- **Bottom-center**: Press Space
- **Screen center**: Press G or H

## Troubleshooting

### "Accessibility permissions required" alert
**Solution**: Grant accessibility permissions in System Preferences > Privacy & Security > Accessibility

### Cursor not moving when pressing keys
**Possible causes**:
1. Trigger key not held down - ensure Fn or Control+Option is pressed
2. Accessibility permissions not granted
3. Key not mapped (rare keys may not be mapped)

**Solution**: 
- Check that trigger key is held
- Verify permissions in System Preferences
- Try common letter keys first

### Keys still typing while in trackpad mode
**Expected behavior**: The app observes key events but doesn't suppress them
- Some keys may still produce output
- Focus may affect which app receives the keypresses
- Consider using the feature when no text field is active

### Cursor warps to wrong location
**Possible causes**:
1. Screen configuration changed (display disconnected/connected)
2. Display arrangement changed

**Solution**: Restart the app to recalculate screen mappings

### Multiple displays: cursor only works on one screen
**Possible causes**:
- Display configuration issue
- Permissions may need refresh

**Solution**: 
1. Restart the app
2. Verify all displays are detected in System Preferences > Displays

## Advanced Configuration

### Changing the Trigger Key
Edit `Sources/KeyboardTrackpad/KeyboardTrackpadMode.swift`:

```swift
// To use ONLY Fn key (disable fallback):
private let useFallbackTrigger = false

// To use ONLY Control+Option (disable Fn):
// Modify handleFlagsChanged() method
let shouldActivate = event.modifierFlags.contains([.control, .option])
```

### Customizing Key Mapping
Edit `Sources/KeyboardTrackpad/KeyboardPositionMapper.swift`:

Adjust the grid size:
```swift
let gridRows = 6    // Increase for finer vertical resolution
let gridCols = 15   // Increase for finer horizontal resolution
```

### Adding Visual Feedback
In `KeyboardTrackpadMode.swift`, add to `activateTrackpadMode()`:

```swift
// Change cursor style
NSCursor.crosshair.set()

// Show notification
let notification = NSUserNotification()
notification.title = "Trackpad Mode"
notification.informativeText = "Active"
NSUserNotificationCenter.default.deliver(notification)
```

## Limitations

- **macOS Only**: Requires macOS 13.0 or later
- **Apple Keyboards**: Optimized for Apple keyboard layouts
- **No Click Simulation**: Only moves cursor, doesn't click
- **No Continuous Motion**: Cursor warps instantly, no smooth movement
- **Accessibility Required**: Must grant system permissions

## System Requirements

- macOS 13.0 (Ventura) or later
- Apple keyboard (built-in or external)
- Accessibility permissions
- At least one display

## Performance

- **CPU Impact**: Minimal - only processes events when trigger is held
- **Memory**: Very light - approximately 10-20 MB
- **Responsiveness**: Near-instant cursor warping (<1ms)
- **Multi-display**: No performance penalty with multiple displays
