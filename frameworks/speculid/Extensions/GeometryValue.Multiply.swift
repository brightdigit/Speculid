import Foundation

public extension GeometryValue {
  public static func * (left: GeometryValue, right: CGFloat) -> GeometryValue {
    switch left {
    case let .height(value):
      return .height(Int(CGFloat(value) * right))
    case let .width(value):
      return .width(Int(CGFloat(value) * right))
    }
  }
}
