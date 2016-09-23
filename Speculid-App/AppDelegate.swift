//
//  AppDelegate.swift
//  Speculid-App
//
//  Created by Leo Dion on 9/22/16.
//
//

import Cocoa
import PocketSVG

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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    #if DEBUG
    print("DEBUG")
      let path = CommandLine.arguments[1]
      let speculidURL = URL(fileURLWithPath: path)
        print(speculidURL)
        if let data = try? Data(contentsOf: speculidURL) {
          if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dictionary = json as? [String : String] {
              if let setRelativePath = dictionary["set"], let sourceRelativePath = dictionary["source"] {
                
                let contentsJSONURL = speculidURL.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
                let sourcePath = speculidURL.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
                print(contentsJSONURL)
                if let contentsJSONData = try? Data(contentsOf: contentsJSONURL) {
                  if let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String : Any] {
                    if let images = contentsJSON?["images"] as? [[String : String]] {
                      //inkscape --export-id=Release --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg
                      //for x in 29 40 58 76 87 80 120 152 167 180 ; do inkscape --without-gui --export-png tictalktoc-app/tictalktoc/Images.xcassets/AppIcon-lite.appiconset/lite${x}.png -w ${x} graphics/icons/logo.svg >/dev/null && echo "exporting appicon_${x}.png" & done
                      for imageSetting in images {
                        if let dimensionStrings = imageSetting["size"]?.firstMatchGroups(regex: sizeRegex), let scaleMatches = imageSetting["scale"]?.firstMatchGroups(regex: scaleRegex) {
                          
                          if let scale = Double(scaleMatches[1]), let width = Double(dimensionStrings[1]), let height = Double(dimensionStrings[2]) {
                            let dimension = height > width ? "-h" : "-w"
                            let length = Int(round(max(width, height) * scale))
                            let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension("\(width.cleanValue)x\(height.cleanValue).\(scale.cleanValue)x.png")
                            
                            let process = Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments:
                              ["--without-gui","--export-png",destinationURL.path,dimension,"\(length)",sourcePath.absoluteURL.path])
                            process.waitUntilExit()
                          }
                        }
                    
                     
                      }
                    }
                  }
                }
              }
            }
          }
        
      }
      
      
    #endif
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

