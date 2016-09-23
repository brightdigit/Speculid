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
      print(speculidURL)
      if let data = try? Data(contentsOf: speculidURL) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
          if let dictionary = json as? [String : String] {
            if let setRelativePath = dictionary["set"], let sourceRelativePath = dictionary["source"] {
              let resize1x = dictionary["size"]
              let contentsJSONURL = speculidURL.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
              let sourcePath = speculidURL.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
              print(contentsJSONURL)
              if let contentsJSONData = try? Data(contentsOf: contentsJSONURL) {
                if let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String : Any] {
                  if let images = contentsJSON?["images"] as? [[String : String]] {
                    //inkscape --export-id=Release --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg
                    //for x in 29 40 58 76 87 80 120 152 167 180 ; do inkscape --without-gui --export-png tictalktoc-app/tictalktoc/Images.xcassets/AppIcon-lite.appiconset/lite${x}.png -w ${x} graphics/icons/logo.svg >/dev/null && echo "exporting appicon_${x}.png" & done
                    let maxScale = images.reduce(nil, { (maxScale, imageSetting) -> Double? in
                      guard let scaleString = imageSetting["scale"]?.firstMatchGroups(regex: scaleRegex)?[1] else {
                        return maxScale
                      }
                      
                      guard let scale = Double(scaleString) else {
                        return maxScale
                      }
                      
                      guard let maxScale = maxScale else {
                        return scale
                      }
                      
                      return max(scale, maxScale)
                    })
                    for imageSetting in images {
                      let process: Process?
                      if let scaleMatches = imageSetting["scale"]?.firstMatchGroups(regex: scaleRegex), let scale = Double(scaleMatches[1]) {
                          
                          if sourcePath.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame {
                            var arguments = ["--without-gui","--export-png"]
                            if let dimensionStrings = imageSetting["size"]?.firstMatchGroups(regex: sizeRegex), let width = Double(dimensionStrings[1]), let height = Double(dimensionStrings[2]) {
                              let dimension = height > width ? "-h" : "-w"
                              let length = Int(round(max(width, height) * scale))
                              let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension("\(width.cleanValue)x\(height.cleanValue).\(scale.cleanValue)x.png")
                              arguments.append(contentsOf: [destinationURL.path,dimension,"\(length)",sourcePath.absoluteURL.path])
                              //process.waitUntilExit()
                            } else {
                              // convert to
                              let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
                              arguments.append(contentsOf: [destinationURL.path,sourcePath.absoluteURL.path])
                              
                              // if svg
                              //process = nil
                              // else
                              //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
                            }
                            
                            
                            //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
                            process = Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments:
                              arguments)
                          } else {
                            let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
                            let resizeValue : String
                            if let resize1x = resize1x {
                              resizeValue = resize1x.replaceRegex(regex: numberRegex, replace: { (matchedString, _) -> String in
                                let value = Int(matchedString)!
                                return "\(value * Int(scale))"
                              })
                            } else if let maxScale = maxScale {
                              resizeValue = "\(round(scale/maxScale*100.0))%"
                            } else {
                              fatalError()
                            }
                            process = Process.launchedProcess(launchPath: "/usr/local/bin/convert", arguments: [sourcePath.path,"-resize",resizeValue,destinationURL.path])
                          }
                      } else {
                          // convert to pdf
                          // inkscape --without-gui --export-area-drawing --export-pdf $ASSET_ROOT/$packname/$imagename-$packname.imageset/icon.pdf $file 2> /dev/null > /dev/null  &
                          let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension("pdf")
                          process = Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments: ["--without-gui","--export-area-drawing","--export-pdf",destinationURL.path,sourcePath.absoluteURL.path])
                        }
                      
                      process?.waitUntilExit()
                      
                      
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

