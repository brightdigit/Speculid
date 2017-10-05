//
//  Geometry.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

extension GeometryValue : CustomStringConvertible {
  func scaledBy(_ scale: Int) -> GeometryValue {
    switch self {
    case .Width(let value) : return .Width(value * scale)
    case .Height(let value): return .Height(value * scale)
    }
  }
  
  public var description : String {
    switch self {
    case .Width(let value): return "\(value)"
    case .Height(let value): return "x\(value)"
    }
  }
}

public struct Geometry : GeometryProtocol {
  public let value: GeometryValue?
  public func text(scaledBy scale: Int) -> String {
    return value!.scaledBy(scale).description
  }
  
  public struct Regex {
    public static let Geometry = try! NSRegularExpression(pattern: "x?(\\d+)", options: [.caseInsensitive])
    public static let Integer = try! NSRegularExpression(pattern: "\\d+", options: [])
    private init () {}
  }
  
  public init?(string: String) {
    let range = NSRange(0..<string.characters.count)
    
    guard (Geometry.Regex.Geometry.firstMatch(in: string, options: [], range: range) != nil) else {
      return nil
    }
    let value : GeometryValue
    let results = Geometry.Regex.Integer.matches(in: string, options: [], range: range)
    let intValue = results.flatMap { (result) -> Int? in
      guard let range = Range(result.range, in: string) else {
        return nil
      }
      return Int(string[range])
      }.first!
    if string.lowercased().characters.first == "x" {
      value = .Height(intValue)
    } else {
      value = .Width(intValue)
    }
    self.value = value
  }
  
  public var description: String {
    return self.value!.description
  }
}
