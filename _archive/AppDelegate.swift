import AppKit
import SpeculidKit

extension NSSize {
  func margined(by value: CGFloat) -> NSSize {
    return NSSize(width: self.width - value * 2, height: self.height - value * 2)
  }
}

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  private var statusBar: NSStatusBar!
  private var statusItem: NSStatusItem!
  private var notificationObject : NSObjectProtocol!
  
  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
    NSApp.setActivationPolicy(.accessory)
    let statusBar = NSStatusBar()
    let statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
    guard let button = statusItem.button else {
      return
    }
    button.image = NSImage(named: "StatusBarIcon")
    button.image?.size = statusItem.button!.bounds.size.margined(by: 3)
    
    let menu = NSMenu()
    menu.items = [
      NSMenuItem(title: "New...", action: nil, keyEquivalent: "N"),
      NSMenuItem(title: "Open...", action: nil, keyEquivalent: "O"),
      NSMenuItem.separator(),
      NSMenuItem(title: "Quit", action: nil, keyEquivalent: "Q")
    ]
    
    statusItem.menu = menu
    
    
    self.statusItem = statusItem
    self.statusBar = statusBar
    
    self.notificationObject = NotificationCenter.default.addObserver(forName: NSNotification.Name("DocumentClosing"), object: nil, queue: nil) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        let policy : NSApplication.ActivationPolicy
        policy = NSDocumentController.shared.documents.count == 0 ? .accessory : .regular
        NSApp.setActivationPolicy(policy)
        
      }
    }
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    NSApp.setActivationPolicy(.regular)
    return true
  }
}
