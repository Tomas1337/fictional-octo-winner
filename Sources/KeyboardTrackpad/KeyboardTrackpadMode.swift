import Cocoa
import ApplicationServices
import Carbon.HIToolbox

class KeyboardTrackpadMode {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var isTrackpadModeActive = false
    private let keyMapper = KeyboardPositionMapper()

    func start() {
        setupEventTap()
    }

    func stop() {
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            self.runLoopSource = nil
        }
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            self.eventTap = nil
        }
        isTrackpadModeActive = false
    }

    private func setupEventTap() {
        let eventMask: CGEventMask = (1 << CGEventType.flagsChanged.rawValue)
            | (1 << CGEventType.keyDown.rawValue)

        let selfPtr = Unmanaged.passUnretained(self).toOpaque()

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                let mode = Unmanaged<KeyboardTrackpadMode>.fromOpaque(refcon).takeUnretainedValue()
                return mode.handleCGEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: selfPtr
        ) else {
            print("KeyboardTrackpad: Failed to create event tap. Check Accessibility permissions.")
            return
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    private func handleCGEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return Unmanaged.passUnretained(event)
        }

        if type == .flagsChanged {
            return handleFlagsChanged(event: event)
        } else if type == .keyDown && isTrackpadModeActive {
            return handleKeyPress(event: event)
        }

        return Unmanaged.passUnretained(event)
    }

    private func handleFlagsChanged(event: CGEvent) -> Unmanaged<CGEvent>? {
        let flags = CGEventFlags(rawValue: event.flags.rawValue)
        let fnKeyPressed = flags.contains(.maskSecondaryFn)
        let fallbackTrigger = flags.contains(.maskControl) && flags.contains(.maskAlternate)

        let shouldActivate = fnKeyPressed || fallbackTrigger

        if shouldActivate && !isTrackpadModeActive {
            isTrackpadModeActive = true
        } else if !shouldActivate && isTrackpadModeActive {
            isTrackpadModeActive = false
        }

        return Unmanaged.passUnretained(event)
    }

    private func handleKeyPress(event: CGEvent) -> Unmanaged<CGEvent>? {
        let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))

        if let position = keyMapper.getScreenPosition(for: keyCode) {
            CGWarpMouseCursorPosition(position)
        }

        // Consume all key events in trackpad mode to prevent typing
        return nil
    }
}
