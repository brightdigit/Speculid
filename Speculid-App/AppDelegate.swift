//
//  AppDelegate.swift
//  Speculid-App
//
//  Created by Leo Dion on 9/22/16.
//
//

import Cocoa

extension Double {
  var cleanValue: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
}

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
}

extension String {
  func firstMatchGroups (regex: NSRegularExpression) -> [String]? {
    let range = NSRange(0..<self.characters.count)
    
    guard let result = regex.firstMatch(in: self, options: [], range: range)  else {
      return nil
    }
    //print(result.range)
    return (0..<result.numberOfRanges).map({ (index) -> String in
      self.substring(with: self.range(from: result.rangeAt(index))!)
    })
    //print(scale.substring(with: scale.range(from: result.rangeAt(1))!))
    
  }
}


let scaleRegex = try! NSRegularExpression(pattern: "(\\d+)x", options: [])
let sizeRegex = try! NSRegularExpression(pattern: "(\\d+\\.?\\d*)x(\\d+\\.?\\d*)", options: [])

let numberRegex = try! NSRegularExpression(pattern: "\\d", options: [])

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    #if DEBUG
      print("DEBUG")
      let path = CommandLine.arguments[1]
      let speculidURL = URL(fileURLWithPath: path)
      let document = SpeculidDocument(url: speculidURL)
      document.build{
        (error) in
      }
      print(speculidURL)
            
      
    #endif
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  
}

