import Foundation
import AppKit

public struct StatusItemProvider: StatusItemProviderProtocol {
  public func statusItem(for _: Any?) -> NSStatusItem {
    let menu = NSMenu(title: "Speculid")
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    item.image = #imageLiteral(resourceName: "TrayIcon")
    item.menu = menu
    return item
  }
}
