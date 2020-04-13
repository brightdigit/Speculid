import Foundation

public protocol CommandLineArgumentProviderProtocol {
  var arguments: [String] { get }
  var environment: [String: String] { get }
}
