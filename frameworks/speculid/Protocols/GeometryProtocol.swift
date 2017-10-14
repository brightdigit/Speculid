import Foundation

public protocol GeometryProtocol: CustomStringConvertible {
  func text(scaledBy scale: Int) -> String
}

extension GeometryProtocol {
  public func scaling(by scale: Int) -> GeometryProtocol {
    return ScaledGeometry(self, byScale: scale)
  }
}
