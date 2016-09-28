//: Playground - noun: a place where people can play

//
//  String.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

extension String {
  func nsRange(from range: Range<String.Index>) -> NSRange {
    let utf16view = self.utf16
    let from = range.lowerBound.samePosition(in: utf16view)
    let to = range.upperBound.samePosition(in: utf16view)
    return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from),
                       utf16view.distance(from: from, to: to))
  }
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
      let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self)
      else { return nil }
    return from ..< to
  }
  
  func replaceRegex(regex: NSRegularExpression, replace: ((String, NSTextCheckingResult) -> String)) -> String {
    let range = NSRange(0..<self.characters.count)
    let results = regex.matches(in: self, options: [], range: range).reversed()
    var newString = self
    for result in results {
      let subrange = self.range(from: result.range)
      let substring = self.substring(with: subrange!)
      newString.replaceSubrange(subrange!, with: replace(substring, result))
    }
    return newString
  }
  
  func firstMatchGroups (regex: NSRegularExpression) -> [String]? {
    let range = NSRange(0..<self.characters.count)
    
    guard let result = regex.firstMatch(in: self, options: [], range: range)  else {
      return nil
    }
    
    return (0..<result.numberOfRanges).map({ (index) -> String in
      self.substring(with: self.range(from: result.rangeAt(index))!)
    })
  }
}

public protocol GeometryProtocol : CustomStringConvertible {
  func text (scaledBy scale: Int) -> String
}

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

public struct ScaledGeometry : GeometryProtocol {
  public func text(scaledBy scale: Int) -> String {
    return self.base.scaling(by: scale * self.scale).description
  }

  public let base: GeometryProtocol
  public let scale: Int
  
  public init (_ base: GeometryProtocol, byScale scale: Int) {
    self.base = base
    self.scale = scale
  }
  
  public var description: String {
    return self.base.text(scaledBy: self.scale)
  }
}

extension GeometryProtocol {
  public func scaling (by scale: Int) -> GeometryProtocol {
    return ScaledGeometry(self, byScale: scale)
  }
}

var str = "\\b(\\d*)x?(\\d*)\\b([\\>\\<\\#\\@\\%^!])?"

let wholeRegex = try! NSRegularExpression(pattern: str, options: [])

let values = ["200%",
"200x50%",
"100x200",
"100x200^",
"100x200!"]

print(values.map({ Geometry(string: $0)!}).flatMap { geometry in [1,2,3].map({geometry.scaling(by: $0)}) }.map{ $0.description })


