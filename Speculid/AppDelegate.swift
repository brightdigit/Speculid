import AppKit
import SpeculidKit

extension NSSize {
  func margined(by value: CGFloat) -> NSSize {
    return NSSize(width: self.width - value * 2, height: self.height - value * 2)
  }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  private var statusBar: NSStatusBar!
  private var statusItem: NSStatusItem!
  
  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
    
    let statusBar = NSStatusBar()
    let statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
    guard let button = statusItem.button else {
      return
    }
    button.image = NSImage(named: "StatusBarIcon")
    button.image?.size = statusItem.button!.bounds.size.margined(by: 3)
    
    self.statusItem = statusItem
    self.statusBar = statusBar
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
  
  func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
    return false
  }
}
