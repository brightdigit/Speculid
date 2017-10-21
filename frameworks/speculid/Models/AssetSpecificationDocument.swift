import Foundation

public struct AssetSpecificationDocument: AssetSpecificationDocumentProtocol, Codable {
  public let images: [AssetSpecificationProtocol]

  public enum CodingKeys: String, CodingKey {
    case images
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let images = try container.decode([AssetSpecification].self, forKey: CodingKeys.images)
    self.images = images
  }

  public func encode(to encoder: Encoder) throws {
    var container = try encoder.container(keyedBy: CodingKeys.self)
    try container.encode(images.map(AssetSpecification.init(specifications:)), forKey: .images)
  }
}
