import Foundation
import CairoSVG

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
}

public struct Geometry: GeometryProtocol {
  public let value: GeometryValue
  public func text(scaledBy scale: Int) -> String {
    return value.scaledBy(scale).description
  }

  public struct Regex {
    //    public static let Geometry = Application.shared.regularExpression[.geometry]
    //    //try! NSRegularExpression(pattern: "x?(\\d+)", options: [.caseInsensitive])
    //    public static let Integer = try! NSRegularExpression(pattern: "\\d+", options: [])
    private init() {}
  }

  public init?(string: String) {
    let range = NSRange(0 ..< string.characters.count)

    let geometryRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .geometry)

    let integerRegex: NSRegularExpression = Application.current.regularExpressions.regularExpression(for: .integer)

    guard geometryRegex.firstMatch(in: string, options: [], range: range) != nil else {
      return nil
    }
    let value: GeometryValue
    let results = integerRegex.matches(in: string, options: [], range: range)
    let intValue = results.flatMap { (result) -> Int? in
      guard let range = Range(result.range, in: string) else {
        return nil
      }
      return Int(string[range])
    }.first!
    if string.lowercased().characters.first == "x" {
      value = .height(intValue)
    } else {
      value = .width(intValue)
    }
    self.value = value
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
