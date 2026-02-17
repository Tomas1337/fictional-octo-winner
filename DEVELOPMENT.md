# Development Guide

## Project Structure

```
KeyboardTrackpad/
├── Package.swift                 # Swift Package Manager manifest
├── Info.plist                    # App metadata and permissions
├── build.sh                      # Build script
├── Sources/
│   └── KeyboardTrackpad/
│       ├── main.swift           # App entry point
│       ├── AppDelegate.swift    # App lifecycle and UI
│       ├── KeyboardTrackpadMode.swift      # Core mode logic
│       └── KeyboardPositionMapper.swift    # Key-to-position mapping
├── README.md                     # User-facing documentation
├── ARCHITECTURE.md              # Technical architecture
├── USAGE.md                     # Usage guide
└── DEVELOPMENT.md               # This file
```

## Development Environment Setup

### Requirements
- macOS 13.0 or later
- Xcode 15.0 or later (for Swift 5.9)
- Swift command line tools
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/Tomas1337/fictional-octo-winner.git
cd fictional-octo-winner

# Build the project
swift build

# Run the project
swift run
```

## Building and Running

### Debug Build
```bash
swift build
.build/debug/KeyboardTrackpad
```

### Release Build
```bash
swift build -c release
.build/release/KeyboardTrackpad
```

### Using the Build Script
```bash
./build.sh
```

## Code Overview

### main.swift
The entry point of the application. Minimal setup:
- Creates NSApplication instance
- Sets AppDelegate
- Starts the run loop

### AppDelegate.swift
Manages application lifecycle:
- **Menu Bar UI**: Creates status bar item with menu
- **Permission Check**: Prompts for Accessibility permissions
- **Initialization**: Creates and starts KeyboardTrackpadMode
- **Cleanup**: Stops mode monitoring on app termination

Key methods:
- `applicationDidFinishLaunching`: App startup
- `setupMenuBar`: Creates menu bar interface
- `checkAccessibilityPermissions`: Checks and requests permissions

### KeyboardTrackpadMode.swift
Core trackpad mode implementation:
- **Event Monitoring**: Listens for keyboard events globally
- **Mode Activation**: Detects trigger key press/release
- **Cursor Warping**: Moves cursor using Quartz APIs
- **Multi-Display**: Handles multiple displays

Key properties:
- `isTrackpadModeActive`: Current mode state
- `globalMonitor`: System-wide event monitor
- `localMonitor`: Local app event monitor
- `keyMapper`: Position mapper instance

Key methods:
- `start()`: Begin monitoring events
- `stop()`: Remove event monitors
- `handleFlagsChanged()`: Detect trigger key
- `handleKeyPress()`: Process key press in trackpad mode
- `warpCursor()`: Move cursor to position

### KeyboardPositionMapper.swift
Maps keyboard keys to screen positions:
- **Key Mapping**: Creates key code to position dictionary
- **Screen Bounds**: Tracks display configuration
- **Grid Layout**: Distributes keys across screen

Key methods:
- `getScreenPosition(for:)`: Get position for key code
- `updateScreenBounds()`: Recalculate display bounds
- `setupKeyMapping()`: Create initial key mappings
- `mapRow()`: Map a row of keys to screen region

## Key Technologies

### Cocoa (AppKit)
```swift
import Cocoa

// Used for:
NSApplication      // App lifecycle
NSStatusBar        // Menu bar integration
NSEvent           // Event monitoring
NSScreen          // Display information
```

### ApplicationServices
```swift
import ApplicationServices

// Used for:
AXIsProcessTrustedWithOptions()  // Check accessibility permissions
CGDisplayMoveCursorToPoint()     // Warp cursor
CGGetActiveDisplayList()         // List displays
CGDisplayBounds()                // Get display bounds
```

### Carbon.HIToolbox
```swift
import Carbon.HIToolbox

// Used for:
// Key code constants (kVK_*)
// Virtual key codes for keyboard mapping
```

## Event Handling Flow

1. **App Launch**
   - AppDelegate.applicationDidFinishLaunching called
   - Check accessibility permissions
   - Create KeyboardTrackpadMode instance
   - Call mode.start()

2. **Event Monitoring Setup**
   - Add global monitor for flagsChanged and keyDown
   - Add local monitor for same events
   - Monitors remain active until app quits

3. **Trigger Key Detection**
   - flagsChanged event received
   - Check for Fn key (modifierFlags.function)
   - Check for Control+Option (fallback)
   - Activate/deactivate mode based on state

4. **Key Press Handling**
   - keyDown event received
   - If mode active: map key to position
   - Warp cursor to position
   - Event passed through to system

5. **Cursor Warping**
   - Get screen position for key
   - Find which display contains position
   - Call CGDisplayMoveCursorToPoint with correct display ID

## Common Development Tasks

### Adding a New Trigger Key
Edit `KeyboardTrackpadMode.swift`:

```swift
private func handleFlagsChanged(_ event: NSEvent) {
    // Add your custom trigger
    let customTrigger = event.modifierFlags.contains(.command)
    
    let shouldActivate = fnKeyPressed || fallbackTrigger || customTrigger
    // ... rest of method
}
```

### Changing Key Mapping Layout
Edit `KeyboardPositionMapper.swift`:

```swift
private func setupKeyMapping() {
    // Modify grid size
    let gridRows = 8  // More rows = finer vertical control
    let gridCols = 20 // More cols = finer horizontal control
    
    // Modify key row definitions
    let row1Keys: [UInt16] = [/* your keys */]
    
    // ... rest of setup
}
```

### Adding Visual Feedback
Edit `KeyboardTrackpadMode.swift`:

```swift
private func activateTrackpadMode() {
    isTrackpadModeActive = true
    
    // Add visual indicator
    NSCursor.crosshair.set()
    
    // Add sound feedback
    NSSound(named: "Ping")?.play()
    
    // Add on-screen overlay
    showOverlay()
}
```

### Implementing Click Simulation
Add to `warpCursor()` in `KeyboardTrackpadMode.swift`:

```swift
private func warpCursor(to point: CGPoint) {
    // ... existing warp code ...
    
    // Simulate click
    let mouseDown = CGEvent(mouseEventSource: nil, 
                           mouseType: .leftMouseDown,
                           mouseCursorPosition: point,
                           mouseButton: .left)
    let mouseUp = CGEvent(mouseEventSource: nil,
                         mouseType: .leftMouseUp,
                         mouseCursorPosition: point,
                         mouseButton: .left)
    
    mouseDown?.post(tap: .cghidEventTap)
    mouseUp?.post(tap: .cghidEventTap)
}
```

## Testing

Since this is a macOS-specific application with system-level permissions:

### Manual Testing Checklist
- [ ] Build succeeds without errors
- [ ] App launches and shows menu bar icon
- [ ] Accessibility permission prompt appears
- [ ] After granting permissions, trigger key activates mode
- [ ] Key presses move cursor to expected positions
- [ ] Releasing trigger exits mode immediately
- [ ] Normal typing works when mode is inactive
- [ ] Multiple displays handled correctly
- [ ] App quits cleanly

### Testing Accessibility Permissions
```bash
# Check if app has accessibility permissions
sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
  "SELECT * FROM access WHERE service='kTCCServiceAccessibility'"
```

### Testing Multi-Display
1. Connect second display
2. Run app
3. Hold trigger and press keys
4. Verify cursor reaches both displays
5. Disconnect display
6. Restart app (to recalculate bounds)
7. Verify single-display operation

## Debugging

### Print Debugging
Add to relevant methods:
```swift
print("Mode active: \(isTrackpadModeActive)")
print("Key code: \(keyCode)")
print("Target position: \(position)")
print("Screen bounds: \(screenBounds)")
```

### Logging Events
Add detailed logging:
```swift
private func handleEvent(_ event: NSEvent) {
    print("Event type: \(event.type)")
    print("Modifiers: \(event.modifierFlags)")
    print("Key code: \(event.keyCode)")
    // ... handle event
}
```

### Debugging Multi-Display Issues
```swift
private func updateScreenBounds() {
    let screens = NSScreen.screens
    print("Display count: \(screens.count)")
    for (i, screen) in screens.enumerated() {
        print("Display \(i): \(screen.frame)")
    }
}
```

## Code Style Guidelines

- Use Swift naming conventions (camelCase for properties/methods)
- Add comments for non-obvious logic
- Keep methods focused and single-purpose
- Use guard for early returns
- Use weak self in closures to avoid retain cycles
- Prefer immutability (let over var) where possible

## Performance Considerations

### Event Monitoring
- Event monitors have minimal overhead
- Only active when app is running
- No polling - event-driven architecture

### Cursor Warping
- CGDisplayMoveCursorToPoint is very fast (<1ms)
- No noticeable latency on modern Macs
- Multi-display check is O(n) where n is display count

### Memory Usage
- No large data structures
- Key mapping dictionary is small (~50-100 entries)
- No caching or state beyond current mode

## Security Considerations

### Accessibility Permissions
- Required for global event monitoring
- User must explicitly grant permission
- Cannot be requested programmatically beyond prompt

### Privacy
- App only monitors key codes, not characters
- No network access
- No data logging or storage
- All processing is local

### Sandboxing
- This app cannot run sandboxed due to:
  - Global event monitoring requirement
  - Accessibility API usage
  - Cursor manipulation

## Distribution

### Building for Distribution
```bash
swift build -c release

# Code signing (requires Apple Developer account)
codesign --force --sign "Developer ID Application: Your Name" \
  .build/release/KeyboardTrackpad
```

### Notarization (Optional)
For distribution outside App Store:
1. Build release binary
2. Code sign with Developer ID
3. Create ZIP archive
4. Submit to Apple for notarization
5. Staple notarization ticket

### Creating .app Bundle
The current project builds a command-line tool. To create a proper .app:
1. Create Xcode project: `swift package generate-xcodeproj`
2. In Xcode, set product type to Application
3. Add Info.plist to bundle
4. Build as macOS app

## Contributing

When making changes:
1. Test on macOS thoroughly
2. Ensure no regressions in existing functionality
3. Update documentation if adding features
4. Follow existing code style
5. Add comments for complex logic

## Resources

### Apple Documentation
- [NSEvent](https://developer.apple.com/documentation/appkit/nsevent)
- [Accessibility API](https://developer.apple.com/documentation/applicationservices/axuielement_h)
- [Quartz Display Services](https://developer.apple.com/documentation/coregraphics/quartz_display_services)
- [Event Taps](https://developer.apple.com/documentation/coregraphics/quartz_event_services)

### Useful Tools
- Console.app - View system logs and events
- Accessibility Inspector - Debug accessibility features
- Instruments - Profile performance
- Xcode - Full IDE with debugging support
