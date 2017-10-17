import Foundation
import AppKit

public protocol StatusItemProviderProtocol {
  func statusItem(for sender: Any?) -> NSStatusItem
}
