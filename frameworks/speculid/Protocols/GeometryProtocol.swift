import Foundation

public protocol GeometryProtocol: CustomStringConvertible {
  @available(*, deprecated: 2.0.0)
  func text(scaledBy scale: Int) -> String

  var value: GeometryValue {
    get
  }
}

extension GeometryProtocol {
  public func scaling(by scale: Int) -> GeometryProtocol {
    return ScaledGeometry(self, byScale: scale)
  }
  public func scaling(by scale: CGFloat?) -> GeometryProtocol {
    guard let scale = scale else {
      return self
    }
    return scaling(by: Int(scale))
  }
}
