import Foundation

public enum AppleWatchRole: String, Codable {
  case notificationCenter, companionSettings, appLauncher, longLook, quickLook
}

public enum AppleWatchType: String, Codable {
  case size38 = "38mm", size40 = "40mm", size42 = "42mm", size44 = "44mm"
}

extension CGFloat {
  var clean: String {
    truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : description
  }
}

public struct AssetSpecification: AssetSpecificationProtocol, Codable {
  public let idiom: ImageIdiom
  public let scale: CGFloat?
  public let size: CGSize?
  public let filename: String?
  public let role: AppleWatchRole?
  public let subtype: AppleWatchType?

  enum CodingKeys: String, CodingKey {
    case idiom
    case scale
    case size
    case filename
    case role
    case subtype
  }

  public init(idiom: ImageIdiom, scale: CGFloat? = nil, size: CGSize? = nil, role: AppleWatchRole? = nil, subtype: AppleWatchType? = nil, filename: String? = nil) {
    self.idiom = idiom
    self.scale = scale
    self.size = size
    self.filename = filename
    self.role = role
    self.subtype = subtype
  }

  public init(specifications: AssetSpecificationProtocol) {
    idiom = specifications.idiom
    scale = specifications.scale
    size = specifications.size
    filename = specifications.filename
    subtype = specifications.subtype
    role = specifications.role
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

    role = try container.decodeIfPresent(AppleWatchRole.self, forKey: .role)
    subtype = try container.decodeIfPresent(AppleWatchType.self, forKey: .subtype)
  }

  func formatSize(_ size: CGSize) -> String {
    "\(size.width.clean)x\(size.height.clean)"
  }

  func formatScale(_ scale: CGFloat) -> String {
    let scale = Int(scale.rounded())
    return "\(scale)x"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if let size = size {
      try container.encode(formatSize(size), forKey: .size)
    }

    if let scale = scale {
      try container.encode(formatScale(scale), forKey: .scale)
    }

    if let filename = filename {
      try container.encode(filename, forKey: .filename)
    }

    if let subtype = subtype {
      try container.encode(subtype, forKey: .subtype)
    }

    if let role = role {
      try container.encode(role, forKey: .role)
    }

    try container.encode(idiom, forKey: .idiom)
  }

  public init?(_ item: AssetCatalogItem) {
    guard let idiom = ImageIdiom(rawValue: item.idiom) else {
      return nil
    }
    self.idiom = idiom
    filename = item.filename
    scale = item.scale?.cgFloatValue
    size = item.size?.cgSize
    role = item.role.flatMap { AppleWatchRole(rawValue: $0) }
    subtype = item.subtype.flatMap { AppleWatchType(rawValue: $0) }
  }
}
