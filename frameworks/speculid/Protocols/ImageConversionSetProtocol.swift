import Foundation

public protocol ImageConversionSetProtocol {
  func run(_ callback: @escaping (Error?) -> Void)
}
