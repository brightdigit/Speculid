import Foundation
@available(*, deprecated: 2.0.0)
public protocol ImageConversionSetProtocol {
  func run(_ callback: @escaping (Error?) -> Void)
}
