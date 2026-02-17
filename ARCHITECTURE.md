# Architecture Documentation

## Overview

KeyboardTrackpad is a macOS menu bar application that transforms an Apple keyboard into a trackpad interface. When a trigger key is held, each keyboard key becomes a button that warps the cursor to a specific screen position.

## Components

### 1. AppDelegate.swift
**Purpose**: Application lifecycle and UI management

**Responsibilities**:
- Menu bar integration
- Accessibility permission checks
- Application startup and shutdown
- User interface (menu items)

**Key APIs Used**:
- `NSApplication` - App lifecycle
- `NSStatusBar` - Menu bar integration
- `AXIsProcessTrustedWithOptions` - Accessibility permission check

### 2. KeyboardTrackpadMode.swift
**Purpose**: Core trackpad mode logic

**Responsibilities**:
- Event monitoring for trigger key
- Mode activation/deactivation
- Key press handling in trackpad mode
- Cursor warping coordination

**Key APIs Used**:
- `NSEvent.addGlobalMonitorForEvents` - Monitor keyboard events system-wide
- `NSEvent.addLocalMonitorForEvents` - Monitor events in the app
- `CGDisplayMoveCursorToPoint` - Warp cursor using Quartz
- `CGGetActiveDisplayList` - Multi-display support

**Event Flow**:
1. Monitor `.flagsChanged` events to detect trigger key press/release
2. When trigger detected → activate mode
3. While active, monitor `.keyDown` events
4. Map key code to screen position
5. Warp cursor to position
6. When trigger released → deactivate mode

### 3. KeyboardPositionMapper.swift
**Purpose**: Keyboard to screen position mapping

**Responsibilities**:
- Map each key code to a screen coordinate
- Handle multi-display configurations
- Update mappings when screen configuration changes

**Mapping Strategy**:
- Keyboard is conceptually divided into a grid
- Each row of keys maps to a horizontal band of the screen
- Within each row, keys are distributed across the screen width
- Special keys (arrows) placed in logical screen positions

**Key APIs Used**:
- `NSScreen.main` - Get main display bounds
- `NSScreen.screens` - Get all displays
- `CGDisplayBounds` - Get display dimensions

## Trigger Key Detection

The app supports two trigger mechanisms:

### Primary: Fn/Globe Key
- Detected via `NSEventModifierFlags.function`
- Native macOS function key modifier
- Preferred trigger for Apple keyboards

### Fallback: Control + Option
- Detected via `NSEventModifierFlags.control` + `.option`
- Alternative for keyboards without Fn key detection
- Configurable via `useFallbackTrigger` flag

## Multi-Display Handling

The app safely handles multiple displays:

1. **Screen Bounds Calculation**:
   - Combines all screen bounds into a unified coordinate space
   - Ensures cursor positions are valid across all displays

2. **Display Targeting**:
   - Checks which display contains the target point
   - Uses the correct display ID for cursor warping
   - Prevents cursor from getting lost on invalid displays

3. **Dynamic Updates**:
   - Screen bounds recalculated on each cursor warp
   - Handles display configuration changes

## Security & Permissions

### Accessibility Permission
**Required for**:
- Global keyboard event monitoring
- Cursor position manipulation

**User Experience**:
- App prompts for permission on first launch
- Shows alert explaining why permission is needed
- User directed to System Preferences if not granted

### Privacy Considerations
- No keyboard data is logged or transmitted
- Only monitors modifier keys and key codes (not characters)
- Mode is completely local - no network access

## Key Code Reference

The app uses Carbon HIToolbox key codes:

```
Row 1 (Numbers):  18-29, 50, 51
Row 2 (QWERTY):   12-17, 32-35, 48, 42
Row 3 (ASDF):     0-5, 37-41, 36, 57
Row 4 (ZXCV):     6-11, 43-47, 56, 60
Row 5 (Space):    49, 54-55, 58, 61
Arrows:           123-126
```

## Normal Typing Preservation

The app ensures normal typing is unaffected:

1. **Event Passthrough**: 
   - Local monitor returns events unchanged
   - System processes keys normally when mode inactive

2. **Mode Isolation**:
   - Key mapping only active when trigger held
   - Immediate deactivation on trigger release

3. **No Event Suppression**:
   - App doesn't suppress or modify key events
   - Only observes and reacts to them

## Future Enhancements

Potential improvements:
- Visual cursor feedback in trackpad mode
- Customizable key mappings
- Configurable trigger keys
- Click simulation on key press
- Multi-key gestures (e.g., Shift+key for right-click)
- On-screen keyboard overlay showing cursor positions
- Calibration wizard for custom layouts
