//
//  Geometry.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

import Cocoa

public struct Geometry : GeometryProtocol {
  public let string : String
  public let subranges : [Range<String.Index>]
  public func text(scaledBy scale: Int) -> String {
    var result = self.string
    for subrange in subranges {
      let value = Int(string.substring(with: subrange))!
      result.replaceSubrange(subrange, with: "\(value * scale)")
    }
    return result
  }
  
  
  public struct Regex {
    public static let Geometry = try! NSRegularExpression(pattern: "\\b(\\d*)x?(\\d*)\\b([\\>\\<\\#\\@\\%^!])?", options: [.caseInsensitive])
    public static let Integer = try! NSRegularExpression(pattern: "\\d+", options: [])
    
  }
  
  public init?(string: String) {
    let range = NSRange(0..<string.characters.count)
    guard (Geometry.Regex.Geometry.firstMatch(in: string, options: [], range: range) != nil) else {
      return nil
    }
    self.string = string
    let results = Geometry.Regex.Integer.matches(in: string, options: [], range: range)
    self.subranges = results.map { (result) -> Range<String.Index> in
      return string.range(from: result.range)!
      }.reversed()
  }
  
  public var description: String {
    return self.string
  }
}
