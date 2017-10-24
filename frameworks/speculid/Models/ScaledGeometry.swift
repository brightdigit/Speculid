import Foundation
public struct ScaledGeometry: GeometryProtocol {
  public func text(scaledBy scale: Int) -> String {
    return base.scaling(by: scale * self.scale).description
  }

  public let base: GeometryProtocol
  public let scale: Int

  public init(_ base: GeometryProtocol, byScale scale: Int) {
    self.base = base
    self.scale = scale
  }

  public var description: String {
    return base.text(scaledBy: scale)
  }

  public var value: GeometryValue {

    return base.value * CGFloat(scale)
  }
}
