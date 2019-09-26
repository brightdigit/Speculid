import Foundation

public protocol AssetSpecificationMetadataProtocol: Codable {
  var author: String { get }
  var version: Int { get }
}
