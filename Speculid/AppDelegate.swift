import Cocoa
import SpeculidKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
    
    do {
    try FileTesting.copyFile(from: URL(fileURLWithPath: #file), to: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("AppDelegate.copy"))
    } catch {
      debugPrint(error)
    }
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
}
