import Foundation
import CairoSVG

public struct BadGeometryStringValueError: Error {
  public let stringValue: String
}

public struct BadGeometryCGSizeValueError: Error {
  public let size: CGSize
}
extension GeometryValue {
  func scaledBy(_ scale: CGFloat) -> GeometryValue {
    switch self {
    case let .width(value) : return .width(value * scale)
    case let .height(value): return .height(value * scale)
    case let .scale(value): return .scale(CGFloat(scale) * value)
    }
  }

  public var description: String {
    switch self {
    case let .width(value): return "\(value)"
    case let .height(value): return "x\(value)"
    case let .scale(value): return "\(value)x"
    }
  }

  public init?(string: String) {

    if let intValue = Double(string) {
      self = .width(CGFloat(intValue))
    } else if let intValue = Double(String(string[string.index(after: string.startIndex)...])), string[string.startIndex] == "x" {
      self = .height(CGFloat(intValue))
    } else {
      return nil
    }
  }
}

extension Geometry {
  public init(size: CGSize, preferWidth: Bool? = true) throws {
    if preferWidth == nil, size.height != size.width {
      throw BadGeometryCGSizeValueError(size: size)
    }

    if preferWidth == false {
      value = .height(size.height)
    } else {
      value = .width(size.width)
    }
  }
}

public struct Geometry: GeometryProtocol, Codable {
  public let value: GeometryValue
  public func text(scaledBy scale: CGFloat) -> String {
    return value.scaledBy(scale).description
  }

  public init(string: String) throws {
    guard let value = GeometryValue(string: string) else {
      throw BadGeometryStringValueError(stringValue: string)
    }
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    guard let value = GeometryValue(string: stringValue) else {
      throw BadGeometryStringValueError(stringValue: stringValue)
    }
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = try encoder.singleValueContainer()
    try container.encode(value.description)
  }

  public init(value: GeometryValue) {
    self.value = value
  }

  internal init?(dimension: CairoSVG.Dimension, value: CGFloat) {
    switch dimension {
    case .height: self.value = .height(value)
    case .width: self.value = .width(value)
    case .scale: self.value = .scale(value)
    case .unspecified: return nil
    }
  }
}
