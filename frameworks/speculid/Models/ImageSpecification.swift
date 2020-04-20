import CairoSVG
import Cocoa

@objc open class ImageSpecification: NSObject, ImageSpecificationProtocol, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(file, forKey: "file")
    aCoder.encode(geometry.dimension.rawValue, forKey: "geometryDimensionValue")
    aCoder.encode(geometry.value, forKey: "geometryValue")
    aCoder.encode(backgroundColor, forKey: "backgroundColor")
    aCoder.encode(removeAlphaChannel, forKey: "removeAlphaChannel")
  }

  // swiftlint:disable identifier_name
  public required init?(coder aDecoder: NSCoder) {
    let _file = aDecoder.decodeObject(forKey: "file") as? ImageFileProtocol
    let _dimensionValue = aDecoder.decodeObject(forKey: "geometryDimensionValue") as? UInt
    let _value = aDecoder.decodeObject(forKey: "geometryValue") as? CGFloat
    let backgroundColor = aDecoder.decodeObject(forKey: "backgroundColor") as? CairoColorProtocol
    let _removeAlphaChannel = aDecoder.decodeObject(forKey: "removeAlphaChannel") as? Bool

    guard let file = _file, let dimensionValue = _dimensionValue, let value = _value, let removeAlphaChannel = _removeAlphaChannel, let dimension = CairoSVG.Dimension(rawValue: dimensionValue) else {
      return nil
    }

    self.file = file
    // geometryDimension = Geometry(dimension: dimension, value: value)
    geometry = GeometryDimension(value: value, dimension: dimension)
    self.backgroundColor = backgroundColor
    self.removeAlphaChannel = removeAlphaChannel
  }

  // swiftlint:enable identifier_name

  public let file: ImageFileProtocol
  public let geometry: GeometryDimension
  public let removeAlphaChannel: Bool
  public let backgroundColor: CairoColorProtocol?
  public init(file: ImageFileProtocol, geometryDimension: GeometryDimension? = nil, removeAlphaChannel: Bool = false, backgroundColor: CairoColorProtocol? = nil) {
    self.file = file
    geometry = geometryDimension ?? GeometryDimension(value: 0, dimension: .unspecified)
    self.removeAlphaChannel = removeAlphaChannel
    self.backgroundColor = backgroundColor
    super.init()
  }
}
