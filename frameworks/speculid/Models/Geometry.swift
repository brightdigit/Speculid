//
//  Geometry.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

import Foundation
import CairoSVG

extension GeometryValue : CustomStringConvertible {
  func scaledBy(_ scale: Int) -> GeometryValue {
    switch self {
    case .width(let value) : return .width(value * scale)
    case .height(let value): return .height(value * scale)
    }
  }
  
  public var description : String {
    switch self {
    case .width(let value): return "\(value)"
    case .height(let value): return "x\(value)"
    }
  }
}

public struct Geometry : GeometryProtocol {
  public let value: GeometryValue
  public func text(scaledBy scale: Int) -> String {
    return value.scaledBy(scale).description
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
      value = .height(intValue)
    } else {
      value = .width(intValue)
    }
    self.value = value
  }
  
  public var description: String {
    return self.value.description
  }
  
  public init (value: GeometryValue) {
    self.value = value
  }
  
  internal init (dimension: CairoSVG.Dimension, value: Int) {
    switch (dimension) {
    case .height: self.value = .height(value)
    case .width: self.value = .width(value)
    }
  }
}
