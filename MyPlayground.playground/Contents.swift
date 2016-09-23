//: Playground - noun: a place where people can play

import Cocoa

let numberRegex = try! NSRegularExpression(pattern: "\\d", options: [])


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
    let range = NSRange(0..<string.characters.count)
    let results = numberRegex.matches(in: self, options: [], range: range).reversed()
    var newString = self
    for result in results {
      let subrange = string.range(from: result.range)
      let substring = string.substring(with: subrange!)
      newString.replaceSubrange(subrange!, with: replace(substring, result))
    }
    return newString
  }
}

let string = "400%"
//let string = "5x5"
let range = NSRange(0..<string.characters.count)

for multiplier in 1...3 {
  let newString = string.replaceRegex(regex: numberRegex, replace: { (string, result) -> String in
    
    let value = Int(string)!
    return "\(value * multiplier)"
  })
  
  print(newString)
}
