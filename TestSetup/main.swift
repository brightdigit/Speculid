//
//  main.swift
//  TestSetup
//
//  Created by Leo Dion on 1/17/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

import Foundation

let folderContentsJson = """
{
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
"""


let appIconUrl = URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/AppIcon.speculid")
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
let appIconSetUrl = assetsUrl.appendingPathComponent("AppIcon.appiconset").appendingPathComponent("Contents.json")
  //URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/Assets.xcassets/AppIcon.appiconset/Contents.json", isDirectory: true)

let imageSetUrl = assetsUrl.appendingPathComponent("ImageSet.imageset").appendingPathComponent("Contents.json") //URL(fileURLWithPath: "/Users/leo/Documents/Projects/Speculid/examples/Assets/Assets.xcassets/ImageSet.imageset/Contents.json", isDirectory: true)

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
  let appIconSetUrl = iconsUrl.appendingPathComponent(components.joined(separator: "-")).appendingPathExtension("appiconset")
  let imageSetUrl = iconsUrl.appendingPathComponent(components.joined(separator: "-")).appendingPathExtension("imageset")
  try! FileManager.default.createDirectory(at: appIconSetUrl, withIntermediateDirectories: false, attributes: nil)
  try! FileManager.default.createDirectory(at: imageSetUrl, withIntermediateDirectories: false, attributes: nil)
  
}
