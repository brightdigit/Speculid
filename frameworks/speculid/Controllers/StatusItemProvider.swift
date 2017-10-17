import Foundation
import AppKit

public struct StatusItemProvider: StatusItemProviderProtocol {
  public func statusItem(for _: Any?) -> NSStatusItem {
    let menu = NSMenu(title: "Speculid")
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    item.title = "Speculid"
    item.menu = menu
    return item
  }
}
