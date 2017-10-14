import Foundation

@available(*, deprecated: 2.0.0)
public protocol ApplicationPathDataSource {
  func applicationPaths(_ closure: @escaping (ApplicationPathDictionary) -> Void)
}
