import Foundation

public protocol AssetSpecificationDocumentProtocol: Codable {
  var images: [AssetSpecificationProtocol] { get }
}
