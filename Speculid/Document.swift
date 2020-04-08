import Cocoa
import SwiftUI

class Document: NSPersistentDocument {
  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }

  override class var autosavesInPlace: Bool {
    return true
  }

  override func makeWindowControllers() {
    // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
    // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
    let contentView = ContentView().environment(\.managedObjectContext, managedObjectContext!)

    // Create the window and set the content view.
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false
    )
    window.center()
    window.contentView = NSHostingView(rootView: contentView)
    let windowController = NSWindowController(window: window)
    addWindowController(windowController)
  }
  
  override func close() {
    NotificationCenter.default.post(name: NSNotification.Name("DocumentClosing"), object: nil)
    super.close()
  }
}
