import Cocoa
import ApplicationServices
import Carbon.HIToolbox

class KeyboardTrackpadMode {
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private var isTrackpadModeActive = false
    private let keyMapper = KeyboardPositionMapper()
    
    // Event types to monitor
    private static let monitoredEvents: NSEvent.EventTypeMask = [.flagsChanged, .keyDown]
    
    // Trigger key detection - Fn key (NSEventModifierFlags doesn't have Fn, so we use function key code)
    // We'll use a fallback with Control+Option as an alternative trigger
    private let useFallbackTrigger = true // Set to false to use Fn key only if detectable
    
    func start() {
        setupEventMonitors()
    }
    
    func stop() {
        if let monitor = globalMonitor {
            NSEvent.removeMonitor(monitor)
            globalMonitor = nil
        }
        if let monitor = localMonitor {
            NSEvent.removeMonitor(monitor)
            localMonitor = nil
        }
    }
    
    private func setupEventMonitors() {
        // Monitor for flags changed to detect trigger key press/release
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: Self.monitoredEvents) { [weak self] event in
            self?.handleEvent(event)
        }
        
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: Self.monitoredEvents) { [weak self] event in
            self?.handleEvent(event)
            return event // Pass through all events - let the system handle them normally
        }
    }
    
    private func handleEvent(_ event: NSEvent) {
        if event.type == .flagsChanged {
            handleFlagsChanged(event)
        } else if event.type == .keyDown && isTrackpadModeActive {
            handleKeyPress(event)
        }
    }
    
    private func handleFlagsChanged(_ event: NSEvent) {
        // Check for Fn key using key code (function key code is 63 on macOS)
        // Or use Control+Option as fallback trigger
        let fnKeyPressed = event.modifierFlags.contains(.function)
        let fallbackTrigger = event.modifierFlags.contains([.control, .option])
        
        let shouldActivate = useFallbackTrigger ? (fnKeyPressed || fallbackTrigger) : fnKeyPressed
        
        if shouldActivate && !isTrackpadModeActive {
            activateTrackpadMode()
        } else if !shouldActivate && isTrackpadModeActive {
            deactivateTrackpadMode()
        }
    }
    
    private func activateTrackpadMode() {
        isTrackpadModeActive = true
        print("Keyboard Trackpad Mode: ACTIVATED")
        
        // Visual feedback could be added here (cursor change, on-screen indicator, etc.)
    }
    
    private func deactivateTrackpadMode() {
        isTrackpadModeActive = false
        print("Keyboard Trackpad Mode: DEACTIVATED")
    }
    
    private func handleKeyPress(_ event: NSEvent) {
        guard isTrackpadModeActive else { return }
        
        let keyCode = event.keyCode
        
        // Get the mapped screen position for this key
        if let position = keyMapper.getScreenPosition(for: keyCode) {
            warpCursor(to: position)
        }
    }
    
    private func warpCursor(to point: CGPoint) {
        // For multi-display support, we need to find which display contains the point
        // and use that display's ID
        let displayCount = UInt32(16) // Maximum displays to check
        var activeDisplays = [CGDirectDisplayID](repeating: 0, count: Int(displayCount))
        var displayCountOut: UInt32 = 0
        
        CGGetActiveDisplayList(displayCount, &activeDisplays, &displayCountOut)
        
        // Find the display that contains the target point and warp cursor there
        for i in 0..<Int(displayCountOut) {
            let displayID = activeDisplays[i]
            let bounds = CGDisplayBounds(displayID)
            
            if bounds.contains(point) {
                CGDisplayMoveCursorToPoint(displayID, point)
                return
            }
        }
        
        // Fallback: if point is not in any display, use main display
        CGDisplayMoveCursorToPoint(CGMainDisplayID(), point)
    }
}
