# KeyboardTrackpad for macOS

**Your keyboard is now a trackpad.** Hold one key, tap another — your cursor teleports. No mouse. No trackpad. Just your keyboard.

KeyboardTrackpad is a lightweight macOS menu bar app that transforms your Apple keyboard into a full-screen cursor controller. Hold the **Fn/Globe** key (or **Control+Option**), press any letter or number key, and the cursor instantly warps to the corresponding position on your screen.

## Why KeyboardTrackpad?

Ever been deep in a coding session, hands on the home row, and had to reach for the mouse just to click something across the screen? That context switch kills your flow.

KeyboardTrackpad eliminates it. Your keyboard becomes a spatial map of your entire screen:

```
┌──────────────────────────────────────────────┐
│  `  1  2  3  4  5  6  7  8  9  0  -  =  ⌫  │  ← Top of screen
│  ⇥  Q  W  E  R  T  Y  U  I  O  P  [  ]  \  │
│  ⇪  A  S  D  F  G  H  J  K  L  ;  '  ⏎     │  ← Middle
│  ⇧  Z  X  C  V  B  N  M  ,  .  /  ⇧        │
│     ⌥  ⌘  ━━━━SPACE━━━━  ⌘  ⌥              │  ← Bottom
└──────────────────────────────────────────────┘
```

Press **F** while holding the trigger — cursor lands in the center-left. Press **O** — it jumps to the upper-right. Every key is a destination.

## Features

- **Instant Cursor Warping** — No animation, no drift. The cursor teleports to the exact screen position mapped to each key. It's as fast as you can type.
- **Zero Learning Curve** — The mapping follows your physical keyboard layout. Top row = top of screen. Bottom row = bottom. Left side = left. Right side = right. You already know where every key is.
- **Two Activation Methods** — Use the **Fn/Globe** key on modern Macs, or **Control+Option** on any keyboard. Both work simultaneously.
- **Multi-Display Support** — Got multiple monitors? The key grid stretches across your entire combined screen space automatically.
- **Lives in Your Menu Bar** — Runs quietly as a menu bar app. No Dock icon, no windows, no distractions. Just a small keyboard icon that lets you know it's running.
- **Normal Typing Unaffected** — KeyboardTrackpad only activates while you hold the trigger key. Release it and your keyboard works exactly as before. Not a single keystroke is intercepted during normal use.
- **No Dependencies** — Pure Swift. No Electron, no frameworks, no bloat. Under 500 lines of code total.

## Getting Started

### From the App Store

1. Download KeyboardTrackpad from the Mac App Store
2. Launch the app — you'll see a keyboard icon appear in your menu bar
3. Grant **Accessibility permissions** when prompted (required for cursor control)
4. Hold **Fn/Globe** (or **Control+Option**), press any key, and watch the cursor jump

### Building from Source

Requires macOS 13.0+ and Swift 5.9+.

```bash
# Clone the repo
git clone https://github.com/Tomas1337/fictional-octo-winner.git
cd fictional-octo-winner

# Build and create a signed .app bundle
./build.sh

# Or build manually
swift build -c release

# Run directly
.build/release/KeyboardTrackpad
```

The build script creates a `KeyboardTrackpad.app` bundle you can drag to your Applications folder.

## How to Use

1. **Launch** — The app starts in your menu bar (keyboard icon)
2. **Hold the trigger** — Press and hold **Fn/Globe** or **Control+Option**
3. **Tap a key** — While holding the trigger, press any key to warp the cursor to that position
4. **Release** — Let go of the trigger key and you're back to normal typing

That's it. Three seconds to learn, and you'll wonder how you lived without it.

### Tips

- **Home row for precision** — The **A-S-D-F-G-H-J-K-L** keys map to a horizontal band across the middle of your screen. Great for reaching toolbar buttons, tabs, and sidebars.
- **Number row for the top** — Need to hit a menu bar item or browser tab? The number keys cover the top edge of your screen.
- **Space bar for center** — Tap space to jump to the dead center of your screen.
- **Arrow keys** — Mapped to the bottom-right corner for fine-grained navigation.

## Requirements

- macOS 13.0 (Ventura) or later
- Apple keyboard (optimized for Apple key layouts)
- Accessibility permissions (the app will prompt you on first launch)

## Privacy & Security

KeyboardTrackpad takes your privacy seriously:

- **No data collection** — Zero analytics, zero telemetry, zero network calls
- **No keylogging** — The app reads key codes (which physical key was pressed), not characters. It never knows what you're typing
- **Fully local** — All processing happens on your Mac. Nothing leaves your device
- **Open source** — Every line of code is right here for you to inspect

## Troubleshooting

**Cursor not moving?**
- Make sure you're holding the trigger key (Fn/Globe or Control+Option) *while* pressing other keys
- Check that Accessibility permissions are enabled: **System Settings > Privacy & Security > Accessibility**
- Try quitting and relaunching the app

**App not appearing in menu bar?**
- Look for the keyboard icon in your menu bar (top-right of your screen)
- If you have many menu bar icons, it may be hidden — try closing other menu bar apps

**Permissions dialog not showing?**
- Open **System Settings > Privacy & Security > Accessibility** manually and add KeyboardTrackpad

## Technical Details

KeyboardTrackpad is built with native macOS APIs:

- **CGEventTap** — Low-level Quartz event interception for reliable key capture, even with modifier keys held
- **CGWarpMouseCursorPosition** — Instant cursor positioning using global Quartz coordinates
- **CGGetActiveDisplayList** — Dynamic multi-display detection and coordinate mapping
- **Carbon HIToolbox** — Hardware-level virtual key code mapping

The app installs a session-level event tap that intercepts `flagsChanged` and `keyDown` events before system-level transformations. This ensures the Fn/Globe key works reliably on all Mac models, including newer Apple Silicon machines where the Globe key triggers system behaviors.

## Contributing

Contributions are welcome! The codebase is intentionally small and focused — four Swift files, no external dependencies.

## License

MIT License — see [LICENSE](LICENSE) for details.

---

**KeyboardTrackpad** — Because reaching for the mouse is so last decade.
