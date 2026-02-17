import Cocoa
import ApplicationServices

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var trackpadMode: KeyboardTrackpadMode!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up menu bar app
        setupMenuBar()
        
        // Initialize keyboard trackpad mode
        trackpadMode = KeyboardTrackpadMode()
        
        // Check for accessibility permissions
        checkAccessibilityPermissions()
        
        // Start monitoring
        trackpadMode.start()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        trackpadMode.stop()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Keyboard Trackpad")
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Keyboard Trackpad Mode", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc private func quit() {
        NSApp.terminate(nil)
    }
    
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            let alert = NSAlert()
            alert.messageText = "Accessibility Permissions Required"
            alert.informativeText = "Please enable accessibility permissions for this app in System Preferences > Privacy & Security > Accessibility."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
