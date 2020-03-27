import Foundation

public protocol AssetSpecificationDocumentProtocol: Codable {
  var info: AssetSpecificationMetadataProtocol { get }
  var images: [AssetSpecificationProtocol] { get }
}
