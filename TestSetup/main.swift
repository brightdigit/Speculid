//
//  main.swift
//  TestSetup
//
//  Created by Leo Dion on 1/17/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

import Foundation

extension URL {
    func relativePath(from base: URL) -> String? {
        // Ensure that both URLs represent files:
        guard self.isFileURL && base.isFileURL else {
            return nil
        }

        // Remove/replace "." and "..", make paths absolute:
        let destComponents = self.standardized.pathComponents
        let baseComponents = base.standardized.pathComponents

        // Find number of common path components:
        var i = 0
        while i < destComponents.count && i < baseComponents.count
            && destComponents[i] == baseComponents[i] {
                i += 1
        }

        // Build relative path:
        var relComponents = Array(repeating: "..", count: baseComponents.count - i)
        relComponents.append(contentsOf: destComponents[i...])
        return relComponents.joined(separator: "/")
    }
}

let folderContentsJson = """
{
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
"""


let appIconSpeculidUrl = URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/AppIcon.speculid")

let imageSetSpeculidUrl = URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/Image Set.speculid")
guard let filePath = CommandLine.arguments.last.flatMap({
  URL(fileURLWithPath: $0)
}) else {
  fatalError()
}

guard let enumerator = FileManager.default.enumerator(at: filePath, includingPropertiesForKeys: nil) else {
  fatalError()
}

let assetsParentUrl = URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets", isDirectory: true)

let speculidIconsUrl = assetsParentUrl.appendingPathComponent("icons", isDirectory: true)
let assetsUrl = assetsParentUrl.appendingPathComponent("Assets.xcassets", isDirectory: true)
let appIconContentsUrl = assetsUrl.appendingPathComponent("AppIcon.appiconset").appendingPathComponent("Contents.json")
  //URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/Assets.xcassets/AppIcon.appiconset/Contents.json", isDirectory: true)

let imageSetContentsUrl = assetsUrl.appendingPathComponent("ImageSet.imageset").appendingPathComponent("Contents.json") //URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/Assets.xcassets/ImageSet.imageset/Contents.json", isDirectory: true)

let iconsUrl = assetsUrl.appendingPathComponent("icons")

let iconsContentsUrl = iconsUrl.appendingPathComponent("Contents.json")


if FileManager.default.fileExists(atPath: iconsUrl.path, isDirectory: nil) {
  try! FileManager.default.removeItem(at: iconsUrl)
}


if FileManager.default.fileExists(atPath: speculidIconsUrl.path, isDirectory: nil) {
  try! FileManager.default.removeItem(at: speculidIconsUrl)
}

try! FileManager.default.createDirectory(at: iconsUrl, withIntermediateDirectories: false, attributes: nil)
try! FileManager.default.createDirectory(at: speculidIconsUrl, withIntermediateDirectories: false, attributes: nil)

try! folderContentsJson.write(to: iconsContentsUrl, atomically: true, encoding: .utf8)


for case let url as URL in enumerator {
  guard url.pathExtension == "svg" else {
    continue
  }
  
  let components = url.deletingPathExtension().pathComponents[filePath.pathComponents.count...]
  let name = components.joined(separator: "-")
  let appIconSetUrl = iconsUrl.appendingPathComponent(name).appendingPathExtension("appiconset")
  let imageSetUrl = iconsUrl.appendingPathComponent(name).appendingPathExtension("imageset")
  let appIconSpecUrl = speculidIconsUrl.appendingPathComponent("\(name).appicon.speculid")
  let imageSetSpecUrl = speculidIconsUrl.appendingPathComponent("\(name).imageset.speculid")
  try! FileManager.default.createDirectory(at: appIconSetUrl, withIntermediateDirectories: false, attributes: nil)
  try! FileManager.default.createDirectory(at: imageSetUrl, withIntermediateDirectories: false, attributes: nil)
  
  try! FileManager.default.copyItem(at: appIconContentsUrl, to: appIconSetUrl.appendingPathComponent("Contents.json"))
  try! FileManager.default.copyItem(at: imageSetContentsUrl, to: imageSetUrl.appendingPathComponent("Contents.json"))
  
  let appIconSpecText = """
{
  "set" : "\(appIconSetUrl.relativePath(from: appIconSpecUrl.deletingLastPathComponent())!)",
"source" : "\(url.relativePath(from: appIconSpecUrl.deletingLastPathComponent())!)",
"background" : "#FFFFFF",
"remove-alpha" : true
}
"""
  
    let imageSetSpecText = """
  {
    "set" : "\(imageSetUrl.relativePath(from: imageSetSpecUrl.deletingLastPathComponent())!)",
  "source" : "\(url.relativePath(from: imageSetSpecUrl.deletingLastPathComponent())!)"
  }
  """
  try! appIconSpecText.write(to: appIconSpecUrl, atomically: true, encoding: .utf8)
  
  //try! FileManager.default.copyItem(at: appIconSpeculidUrl, to: appIconSpecUrl)
 //   try! FileManager.default.copyItem(at: imageSetSpeculidUrl, to:
  //    imageSetSpecUrl)
  
  try! imageSetSpecText.write(to: imageSetSpecUrl, atomically: true, encoding: .utf8)
}
