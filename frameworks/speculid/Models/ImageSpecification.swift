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
    geometryDimension = Geometry(dimension: dimension, value: value)
    self.backgroundColor = backgroundColor
    self.removeAlphaChannel = removeAlphaChannel
  }

  public let file: ImageFileProtocol
  public let geometryDimension: Geometry?
  public let removeAlphaChannel: Bool
  public let backgroundColor: CairoColorProtocol?
  public init(file: ImageFileProtocol, geometryDimension: Geometry? = nil, removeAlphaChannel: Bool = false, backgroundColor: CairoColorProtocol? = nil) {
    self.file = file
    self.geometryDimension = geometryDimension
    self.removeAlphaChannel = removeAlphaChannel
    self.backgroundColor = backgroundColor
    super.init()
  }

  public var geometry: CairoSVG.GeometryDimension {
    guard let geometryDimension = self.geometryDimension else {
      return CairoSVG.GeometryDimension(value: 0, dimension: .unspecified)
    }
    switch geometryDimension.value {
    case let .height(value): return CairoSVG.GeometryDimension(value: value, dimension: .height)
    case let .width(value): return CairoSVG.GeometryDimension(value: value, dimension: .width)
    case let .scale(value): return CairoSVG.GeometryDimension(value: value, dimension: .scale)
    }
  }
}
