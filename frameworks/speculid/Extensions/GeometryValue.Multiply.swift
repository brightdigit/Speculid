import Foundation

public extension GeometryValue {
  public static func * (left: GeometryValue, right: CGFloat) -> GeometryValue {
    switch left {
    case let .height(value):
      return .height(value * right)
    case let .width(value):
      return .width(value * right)
    case let .scale(value):
      return .scale(value * right)
    }
  }
}
