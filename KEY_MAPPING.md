# Key Mapping Reference

This document provides a visual reference for how keyboard keys map to screen positions.

## Keyboard Layout to Screen Mapping

The keyboard is divided into regions that correspond to screen areas:

```
╔════════════════════════════════════════════════════════════════════╗
║                          TOP OF SCREEN                             ║
║  ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐                       ║
║  │` │1 │2 │3 │4 │5 │6 │7 │8 │9 │0 │- │= │  Number Row            ║
║  └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘                       ║
╠════════════════════════════════════════════════════════════════════╣
║                        UPPER-MIDDLE SCREEN                         ║
║  ┌───┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐                      ║
║  │Tab│Q │W │E │R │T │Y │U │I │O │P │[ │] │  QWERTY Row          ║
║  └───┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘                      ║
╠════════════════════════════════════════════════════════════════════╣
║                          MIDDLE SCREEN                             ║
║  ┌────┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬───┐                    ║
║  │Caps│A │S │D │F │G │H │J │K │L │; │' │Ret│  Home Row          ║
║  └────┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴───┘                    ║
╠════════════════════════════════════════════════════════════════════╣
║                        LOWER-MIDDLE SCREEN                         ║
║  ┌─────┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬─────┐                    ║
║  │Shift│Z │X │C │V │B │N │M │, │. │/ │Shift│  Bottom Letter Row ║
║  └─────┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴─────┘                    ║
╠════════════════════════════════════════════════════════════════════╣
║                         BOTTOM OF SCREEN                           ║
║  ┌────┬────┬───────────────────┬────┬────┐                       ║
║  │Ctrl│Opt │      SPACE        │Cmd │Opt │  Modifier Row         ║
║  └────┴────┴───────────────────┴────┴────┘                       ║
╚════════════════════════════════════════════════════════════════════╝
```

## Screen Coordinate Examples

Assuming a 1920x1080 display:

### Top Row (Numbers)
- **`** (Grave): ~(128, 180)
- **1**: ~(192, 180)
- **5**: ~(640, 180) - Left-center top
- **9**: ~(1152, 180)
- **0**: ~(1280, 180)

### QWERTY Row
- **Q**: ~(192, 360) - Upper left quadrant
- **E**: ~(384, 360)
- **T**: ~(640, 360) - Upper center
- **I**: ~(1024, 360)
- **P**: ~(1408, 360) - Upper right quadrant

### Home Row (ASDF)
- **A**: ~(192, 540) - Middle left
- **D**: ~(384, 540)
- **G/H**: ~(640, 540) - Screen center
- **K**: ~(896, 540)
- **;**: ~(1408, 540) - Middle right

### Bottom Letter Row
- **Z**: ~(256, 720) - Lower left quadrant
- **C**: ~(384, 720)
- **V**: ~(512, 720)
- **N**: ~(768, 720) - Lower center
- **M**: ~(896, 720)
- **/**: ~(1280, 720) - Lower right quadrant

### Modifier Row
- **Left Ctrl/Opt**: ~(256, 900) - Bottom left area
- **Space**: ~(640, 900) - Bottom center
- **Right Cmd/Opt**: ~(1280, 900) - Bottom right area

## Strategic Key Positions

### Screen Corners
- **Top-Left**: Press `1` or `Q`
- **Top-Right**: Press `0` or `P`
- **Bottom-Left**: Press `Z` or Left Ctrl
- **Bottom-Right**: Press `/` or Right Option

### Screen Edges
- **Top Edge**: Number row (1-0)
- **Left Edge**: Left column (Q, A, Z)
- **Right Edge**: Right column (P, ;, /)
- **Bottom Edge**: Space bar and modifiers

### Screen Center
- **Exact Center**: Press `G` or `H` (home row center)
- **Upper Center**: Press `T` or `Y`
- **Lower Center**: Press `V` or `B`

## Multi-Display Example

For a dual-monitor setup (two 1920x1080 displays side-by-side):

```
┌─────────────────────┬─────────────────────┐
│   Display 1 (Main)  │   Display 2         │
│   1920x1080         │   1920x1080         │
│                     │                     │
│  Q  W  E  R  T     │     Y  U  I  O  P   │
│  A  S  D  F  G     │     H  J  K  L  ;   │
│  Z  X  C  V  B     │     N  M  ,  .  /   │
│                     │                     │
│  Left keys map to   │  Right keys map to  │
│  left display       │  right display      │
└─────────────────────┴─────────────────────┘
```

In this setup:
- Left-side keys (Q, A, Z, 1-5) → Display 1
- Right-side keys (U, I, O, P, ;, 8-0) → Display 2
- Center keys (T, Y, G, H) → Border between displays

## Usage Patterns

### Quick Navigation
1. **Jump to top-left**: Hold Fn/Globe, press `Q`
2. **Jump to center**: Hold Fn/Globe, press `G`
3. **Jump to bottom-right**: Hold Fn/Globe, press `/`

### Precision Work
1. Use corner keys to quickly reach screen corners
2. Use center keys (G/H) as a "home" position
3. Use adjacent keys to fine-tune position

### Multi-Display Workflow
1. Use left-hand keys to target left display
2. Use right-hand keys to target right display
3. Use number row for quick top-edge access across displays

## Tips

- **Remember by position**: The key's physical position on the keyboard matches its screen position
- **Left-to-Right**: Keys on the left of the keyboard map to left of screen
- **Top-to-Bottom**: Rows from top to bottom map top to bottom on screen
- **Symmetry**: The keyboard layout mirrors the screen layout

## Visual Memory Aid

Think of your keyboard as a miniature touchpad:
- Your left hand controls the left half of the screen
- Your right hand controls the right half of the screen
- Higher rows = higher on screen
- Lower rows = lower on screen
- Space bar = bottom center (natural resting position)

## Customization

The default mapping distributes keys evenly across the screen. To customize:

1. Edit `Sources/KeyboardTrackpad/KeyboardPositionMapper.swift`
2. Adjust `gridRows` and `gridCols` for finer/coarser control
3. Modify individual key positions in the mapping arrays
4. Rebuild the app

Example custom mapping:
```swift
// Make G/H exactly center
keyToPositionMap[4] = CGPoint(x: screenBounds.midX, y: screenBounds.midY)  // G
keyToPositionMap[38] = CGPoint(x: screenBounds.midX, y: screenBounds.midY) // H
```
