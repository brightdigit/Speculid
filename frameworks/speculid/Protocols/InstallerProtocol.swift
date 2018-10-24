import Foundation

@objc public protocol InstallerProtocol {
  func hello(name: String, _ completed: (String) -> Void)
}
