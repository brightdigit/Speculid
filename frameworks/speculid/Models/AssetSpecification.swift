import Foundation

public struct AssetSpecification: AssetSpecificationProtocol, Codable {
  public let idiom: ImageIdiom
  public let scale: CGFloat?
  public let size: CGSize?
  public let filename: String?

  enum CodingKeys: String, CodingKey {
    case idiom
    case scale
    case size
    case filename
  }
  public init(idiom: ImageIdiom, scale: CGFloat? = nil, size: CGSize? = nil, filename: String? = nil) {
    self.idiom = idiom
    self.scale = scale
    self.size = size
    self.filename = filename
  }

  public init(specifications: AssetSpecificationProtocol) {
    idiom = specifications.idiom
    scale = specifications.scale
    size = specifications.size
    filename = specifications.filename
  }

  public init(from decoder: Decoder) throws {
    let scaleRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .scale)
    let sizeRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .size)

    let container = try decoder.container(keyedBy: CodingKeys.self)

    idiom = try container.decode(ImageIdiom.self, forKey: .idiom)
    filename = try container.decodeIfPresent(String.self, forKey: .filename)
    if let scaleString = try container.decodeIfPresent(String.self, forKey: .scale) {
      guard let scaleValueString = scaleString.firstMatchGroups(regex: scaleRegex)?[1], let scale = Double(scaleValueString) else {
        throw DecodingError.dataCorruptedError(forKey: .scale, in: container, debugDescription: scaleString)
      }
      self.scale = CGFloat(scale)
    } else {
      scale = nil
    }

    if let sizeString = try container.decodeIfPresent(String.self, forKey: .size) {
      guard let sizeValueStrings = sizeString.firstMatchGroups(regex: sizeRegex), let width = Double(sizeValueStrings[1]), let height = Double(sizeValueStrings[2]) else {
        throw DecodingError.dataCorruptedError(forKey: .size, in: container, debugDescription: sizeString)
      }
      size = CGSize(width: width, height: height)
    } else {
      size = nil
    }

    //
    //
    //    if let scaleString = dictionary["scale"]?.firstMatchGroups(regex: scaleRegex)?[1], let value = Double(scaleString) {
    //      scale = CGFloat(value)
    //    } else {
    //      scale = nil
    //    }
    //
    //    guard let idiomString = dictionary["idiom"], let idiom = ImageIdiom(rawValue: idiomString) else {
    //      return nil
    //    }
    //
    //
    //
    //    if let dimensionStrings = dictionary["size"]?.firstMatchGroups(regex: sizeRegex), let width = Double(dimensionStrings[1]), let height = Double(dimensionStrings[2]) {
    //      size = CGSize(width: width, height: height)
    //    } else {
    //      size = nil
    //    }
  }

  public func encode(to _: Encoder) throws {}
}
