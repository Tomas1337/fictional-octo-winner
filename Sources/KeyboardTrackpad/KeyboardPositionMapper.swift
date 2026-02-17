import Cocoa
import ApplicationServices

class KeyboardPositionMapper {
    private var keyToPositionMap: [UInt16: CGPoint] = [:]
    private var lastScreenBounds: CGRect = .zero

    init() {
        rebuildKeyMap()
    }

    func getScreenPosition(for keyCode: UInt16) -> CGPoint? {
        let currentBounds = Self.quartzScreenBounds()
        if !boundsApproximatelyEqual(currentBounds, lastScreenBounds) {
            rebuildKeyMap()
        }
        return keyToPositionMap[keyCode]
    }

    private func boundsApproximatelyEqual(_ a: CGRect, _ b: CGRect, tolerance: CGFloat = 1.0) -> Bool {
        return abs(a.origin.x - b.origin.x) < tolerance
            && abs(a.origin.y - b.origin.y) < tolerance
            && abs(a.width - b.width) < tolerance
            && abs(a.height - b.height) < tolerance
    }

    // MARK: - Screen bounds (Quartz coordinate system, origin top-left)

    private static func quartzScreenBounds() -> CGRect {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount)

        if displayCount == 0 {
            return CGDisplayBounds(CGMainDisplayID())
        }

        var displays = [CGDirectDisplayID](repeating: 0, count: Int(displayCount))
        CGGetActiveDisplayList(displayCount, &displays, &displayCount)

        var combined = CGDisplayBounds(displays[0])
        for i in 1..<Int(displayCount) {
            combined = combined.union(CGDisplayBounds(displays[i]))
        }
        return combined
    }

    // MARK: - Key mapping

    private func rebuildKeyMap() {
        lastScreenBounds = Self.quartzScreenBounds()
        keyToPositionMap.removeAll(keepingCapacity: true)
        setupKeyMapping()
    }

    private func setupKeyMapping() {
        let gridRows = 6
        let gridCols = 15

        let cellWidth = lastScreenBounds.width / CGFloat(gridCols)
        let cellHeight = lastScreenBounds.height / CGFloat(gridRows)

        // Row 1: Number row
        let row1Keys: [UInt16] = [
            50,  // ` (grave/tilde)
            18, 19, 20, 21, 23, 22, 26, 28, 25, 29, // 1-9, 0
            27, 24, // - =
            51   // Delete/Backspace
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
            57, // Caps Lock
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

        // Row 6: Arrow keys
        let row6Keys: [UInt16] = [
            123, // Left arrow
            124, // Right arrow
            125, // Down arrow
            126  // Up arrow
        ]

        mapRow(keys: row1Keys, row: 0, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row2Keys, row: 1, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row3Keys, row: 2, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row4Keys, row: 3, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapRow(keys: row5Keys, row: 4, gridCols: gridCols, cellWidth: cellWidth, cellHeight: cellHeight)
        mapArrowKeys(keys: row6Keys, cellWidth: cellWidth, cellHeight: cellHeight)
    }

    private func mapRow(keys: [UInt16], row: Int, gridCols: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
        let rowCount = keys.count
        let yPosition = lastScreenBounds.minY + (CGFloat(row) + 0.5) * cellHeight

        for (index, keyCode) in keys.enumerated() {
            let xPosition = lastScreenBounds.minX + (CGFloat(index) + 0.5) * cellWidth * (CGFloat(gridCols) / CGFloat(rowCount))
            keyToPositionMap[keyCode] = CGPoint(x: xPosition, y: yPosition)
        }
    }

    private func mapArrowKeys(keys: [UInt16], cellWidth: CGFloat, cellHeight: CGFloat) {
        let baseX = lastScreenBounds.maxX - cellWidth * 3
        let baseY = lastScreenBounds.maxY - cellHeight * 1.5

        if keys.count >= 4 {
            keyToPositionMap[keys[0]] = CGPoint(x: baseX, y: baseY)                          // Left
            keyToPositionMap[keys[1]] = CGPoint(x: baseX + cellWidth * 2, y: baseY)           // Right
            keyToPositionMap[keys[2]] = CGPoint(x: baseX + cellWidth, y: baseY + cellHeight * 0.5) // Down
            keyToPositionMap[keys[3]] = CGPoint(x: baseX + cellWidth, y: baseY - cellHeight * 0.5) // Up
        }
    }
}
