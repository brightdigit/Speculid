import Foundation
import CairoSVG

public struct BadGeometryValueError: Error {
  public let stringValue: String
}
extension GeometryValue: CustomStringConvertible {
  func scaledBy(_ scale: Int) -> GeometryValue {
    switch self {
    case let .width(value) : return .width(value * scale)
    case let .height(value): return .height(value * scale)
    }
  }

  public var description: String {
    switch self {
    case let .width(value): return "\(value)"
    case let .height(value): return "x\(value)"
    }
  }

  public init?(string: String) {
    if let intValue = Int(string) {
      self = .width(intValue)
    } else if let intValue = Int(String(string[string.index(after: string.startIndex)...])), string[string.startIndex] == "x" {
      self = .height(intValue)
    } else {
      return nil
    }
  }
}

public struct Geometry: GeometryProtocol, Codable {
  public let value: GeometryValue
  public func text(scaledBy scale: Int) -> String {
    return value.scaledBy(scale).description
  }

  public init(string: String) throws {
    guard let value = GeometryValue(string: string) else {
      throw BadGeometryValueError(stringValue: string)
    }
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    guard let value = GeometryValue(string: stringValue) else {
      throw BadGeometryValueError(stringValue: stringValue)
    }
    self.value = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = try encoder.singleValueContainer()
    try container.encode(value.description)
  }

  public var description: String {
    return value.description
  }

  public init(value: GeometryValue) {
    self.value = value
  }

  internal init(dimension: CairoSVG.Dimension, value: Int) {
    switch dimension {
    case .height: self.value = .height(value)
    case .width: self.value = .width(value)
    }
  }
}
