import Foundation

@objc public protocol InstallerProtocol {
  func installCommandLineTool(fromBundleURL bundleURL: URL, _ completed: @escaping (NSError?) -> Void)
}
