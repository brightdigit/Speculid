import Foundation

@objc public protocol InstallerProtocol {
  func hello(name: String, _ completed: @escaping (String) -> Void)
  func installCommandLineTool(fromBundleURL bundleURL: URL, _ completed: @escaping (NSError?) -> Void)
}
