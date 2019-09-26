import Foundation

public struct AssetSpecificationDocument: AssetSpecificationDocumentProtocol, Codable {
  public let info: AssetSpecificationMetadataProtocol
  public let images: [AssetSpecificationProtocol]

  public enum CodingKeys: String, CodingKey {
    case images
    case info
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let info = try container.decode(AssetSpecificationMetadata.self, forKey: .info)
    let images = try container.decode([AssetSpecification].self, forKey: CodingKeys.images)
    self.images = images
    self.info = info
  }

  public func encode(to encoder: Encoder) throws {
    var container = try encoder.container(keyedBy: CodingKeys.self)

    try container.encode(images.map(AssetSpecification.init(specifications:)), forKey: .images)
    try container.encode(AssetSpecificationMetadata(info), forKey: .info)
  }

  public init(fromItems items: [AssetCatalogItem]) {
    images = items.compactMap(AssetSpecification.init)
    info = AssetSpecificationMetadata()
  }
}
