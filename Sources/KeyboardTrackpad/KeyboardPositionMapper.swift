import Cocoa
import ApplicationServices

class KeyboardPositionMapper {
    private var keyToPositionMap: [UInt16: CGPoint] = [:]
    private var screenBounds: CGRect = .zero
    
    init() {
        updateScreenBounds()
        setupKeyMapping()
    }
    
    func getScreenPosition(for keyCode: UInt16) -> CGPoint? {
        // Update screen bounds in case displays changed
        updateScreenBounds()
        
        return keyToPositionMap[keyCode]
    }
    
    private func updateScreenBounds() {
        // Get the main screen bounds
        if let mainScreen = NSScreen.main {
            screenBounds = mainScreen.frame
        } else {
            // Fallback to display bounds
            let mainDisplayID = CGMainDisplayID()
            screenBounds = CGDisplayBounds(mainDisplayID)
        }
        
        // For multi-display support, we could combine all screen bounds
        // For now, we'll use the main screen
        let screens = NSScreen.screens
        if screens.count > 1 {
            // Calculate combined bounds of all screens
            var combinedBounds = screenBounds
            for screen in screens {
                combinedBounds = combinedBounds.union(screen.frame)
            }
            screenBounds = combinedBounds
        }
    }
    
    private func setupKeyMapping() {
        // Map keyboard keys to screen positions
        // We'll map the keyboard layout to a grid that covers the screen
        
        // Standard Apple keyboard layout (approximate key positions)
        // Using key codes from Carbon.HIToolbox
        
        let gridRows = 6 // Number of rows in keyboard
        let gridCols = 15 // Approximate number of columns
        
        let cellWidth = screenBounds.width / CGFloat(gridCols)
        let cellHeight = screenBounds.height / CGFloat(gridRows)
        
        // Row 1: Number row and function keys area
        let row1Keys: [UInt16] = [
            50, // ` (grave/tilde)
            18, 19, 20, 21, 23, 22, 26, 28, 25, 29, // 1-9, 0
            27, 24, // - =
            51  // Delete/Backspace
        ]
        
        // Row 2: Top letter row (QWERTYUIOP)
        let row2Keys: [UInt16] = [
            48, // Tab
            12, 13, 14, 15, 17, 16, 32, 34, 31, 35, // Q W E R T Y U I O P
            33, 30, // [ ]
            42  // \ (backslash)
        ]
        
        // Row 3: Middle letter row (ASDFGHJKL)
        let row3Keys: [UInt16] = [
            57, // Caps Lock (we'll use it as a key position)
            0, 1, 2, 3, 5, 4, 38, 40, 37, // A S D F G H J K L
            41, 39, // ; '
            36  // Return
        ]
        
        // Row 4: Bottom letter row (ZXCVBNM)
        let row4Keys: [UInt16] = [
            56, // Left Shift
            6, 7, 8, 9, 11, 45, 46, 43, 47, // Z X C V B N M , .
            44, // /
            60  // Right Shift
        ]
        
        // Row 5: Bottom row (modifiers and space)
        let row5Keys: [UInt16] = [
            58, // Left Option
            55, // Left Command
            49, // Space
            54, // Right Command
            61, // Right Option
        ]
        
        // Row 6: Arrow keys (we'll place these at bottom right)
        let row6Keys: [UInt16] = [
            123, // Left arrow
            124, // Right arrow
            125, // Down arrow
            126  // Up arrow
        ]
        
        // Map each row
        mapRow(keys: row1Keys, row: 0, totalRows: gridRows, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row2Keys, row: 1, totalRows: gridRows, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row3Keys, row: 2, totalRows: gridRows, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row4Keys, row: 3, totalRows: gridRows, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row5Keys, row: 4, totalRows: gridRows, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        
        // Map arrow keys to bottom right corner
        mapArrowKeys(keys: row6Keys, cellWidth: cellWidth, cellHeight: cellHeight)
        
        print("Mapped \(keyToPositionMap.count) keys to screen positions")
        print("Screen bounds: \(screenBounds)")
    }
    
    private func mapRow(keys: [UInt16], row: Int, totalRows: Int, gridCols: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
        let rowCount = keys.count
        let yPosition = screenBounds.minY + (CGFloat(row) + 0.5) * cellHeight
        
        for (index, keyCode) in keys.enumerated() {
            let xPosition = screenBounds.minX + (CGFloat(index) + 0.5) * cellWidth * (CGFloat(gridCols) / CGFloat(rowCount))
            let position = CGPoint(x: xPosition, y: yPosition)
            keyToPositionMap[keyCode] = position
        }
    }
    
    private func mapArrowKeys(keys: [UInt16], cellWidth: CGFloat, cellHeight: CGFloat) {
        // Place arrow keys in bottom right area
        let baseX = screenBounds.maxX - cellWidth * 3
        let baseY = screenBounds.maxY - cellHeight * 1.5
        
        if keys.count >= 4 {
            keyToPositionMap[keys[0]] = CGPoint(x: baseX, y: baseY) // Left
            keyToPositionMap[keys[1]] = CGPoint(x: baseX + cellWidth * 2, y: baseY) // Right
            keyToPositionMap[keys[2]] = CGPoint(x: baseX + cellWidth, y: baseY + cellHeight * 0.5) // Down
            keyToPositionMap[keys[3]] = CGPoint(x: baseX + cellWidth, y: baseY - cellHeight * 0.5) // Up
        }
    }
}
