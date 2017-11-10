import Foundation
public struct ScaledGeometry: GeometryProtocol {

  public let base: GeometryProtocol
  public let scale: Int

  public init(_ base: GeometryProtocol, byScale scale: Int) {
    self.base = base
    self.scale = scale
  }

  public var value: GeometryValue {

    return base.value * CGFloat(scale)
  }
}
