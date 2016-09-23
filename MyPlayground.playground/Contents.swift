//: Playground - noun: a place where people can play

import Cocoa

extension String {
  func nsRange(from range: Range<String.Index>) -> NSRange {
    let utf16view = self.utf16
    let from = range.lowerBound.samePosition(in: utf16view)
    let to = range.upperBound.samePosition(in: utf16view)
    return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from),
                       utf16view.distance(from: from, to: to))
  }
}

extension String {
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
      let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self)
      else { return nil }
    return from ..< to
  }
}

var str = "Hello, playground"

let regex = try? NSRegularExpression(pattern: "(\\d+)x", options: [])
let scale = "10x"



let scaleValue = Int(scale)
let range = NSRange(0..<scale.characters.count)


//print(regex?.matches(in: scale, options: [], range: range))
if let result = regex?.firstMatch(in: scale, options: [], range: range) {
  print(result.range)
  
  print(scale.substring(with: scale.range(from: result.rangeAt(1))!))
}
