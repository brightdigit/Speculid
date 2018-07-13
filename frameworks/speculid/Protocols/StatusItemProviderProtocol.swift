import AppKit
import Foundation

public protocol StatusItemProviderProtocol {
  func statusItem(for sender: Any?) -> NSStatusItem
}
