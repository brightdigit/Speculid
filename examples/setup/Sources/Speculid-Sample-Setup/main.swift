//
//  main.swift
//  TestSetup
//
//  Created by Leo Dion on 4/18/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

import Foundation
import PromiseKit // @mxcl ~> 6.5
import ZIPFoundation // @weichsel ~> 0.9.0

func uncompressedString(fromCompressedBase64 compressedBase64String: String) throws -> Data {
  guard let data = Data(base64Encoded: compressedBase64String) else {
    throw NSError()
  }
  
  let nsData = data as NSData
  
  let decompressedNsData: NSData
  decompressedNsData = try nsData.decompressed(using: .lzma)
  
  let decompressedData = decompressedNsData as Data
  guard let object = try? JSONSerialization.jsonObject(with: decompressedData, options: []),
    let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {
      return decompressedData
  }
  
  return jsonData
}

extension URL {
  func relativePath(from base: URL) -> String? {
    // Ensure that both URLs represent files:
    guard isFileURL, base.isFileURL else {
      return nil
    }
    
    // this is the new part, clearly, need to use workBase in lower part
    var workBase = base
    if workBase.pathExtension != "" {
      workBase = workBase.deletingLastPathComponent()
    }
    
    // Remove/replace "." and "..", make paths absolute:
    let destComponents = standardized.resolvingSymlinksInPath().pathComponents
    let baseComponents = workBase.standardized.resolvingSymlinksInPath().pathComponents
    
    // Find number of common path components:
    var index = 0
    while index < destComponents.count,
      index < baseComponents.count,
      destComponents[index] == baseComponents[index] {
        index += 1
    }
    
    // Build relative path:
    var relComponents = Array(repeating: "..", count: baseComponents.count - index)
    relComponents.append(contentsOf: destComponents[index...])
    return relComponents.joined(separator: "/")
  }
}

func createAssetFolder(at url: URL) throws {
  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
  let fileUrl = url.appendingPathComponent("Contents.json")
  try folderContentsJson.write(to: fileUrl, atomically: true, encoding: .utf8)
}

func setup(svgUrl: URL, relativeTo svgDirectoryUrl: URL, withName name: String, _ completed: (Error?) -> Void) {
  guard let parentPath = svgUrl.deletingLastPathComponent().relativePath(from: svgDirectoryUrl) else {
    completed(NSError())
    return
  }
  
  let imageSetSpeculidUrl: URL
  let appIconSpeculidUrl: URL
  let imageSetAssetDirUrl: URL
  let appIconAssetDirUrl: URL
  
  let svgName = svgUrl.deletingPathExtension().lastPathComponent
  
  let speculidDirUrl = speculidUrl.appendingPathComponent(name, isDirectory: true).appendingPathComponent(parentPath, isDirectory: true)
  
  try? FileManager.default.createDirectory(at: speculidDirUrl, withIntermediateDirectories: true)
  
  let imageSetNameAssetDirUrl = imageSetsUrl.appendingPathComponent(name)
  
  let appIconNameAssetDirUrl = appIconsUrl.appendingPathComponent(name)
  
  try? createAssetFolder(at: imageSetNameAssetDirUrl)
  try? createAssetFolder(at: appIconNameAssetDirUrl)
  let imageSetAssetParentDirUrl = imageSetNameAssetDirUrl.appendingPathComponent(parentPath, isDirectory: true)
  try? createAssetFolder(at: imageSetAssetParentDirUrl)
  let appIconAssetParentDirUrl = appIconNameAssetDirUrl.appendingPathComponent(parentPath, isDirectory: true)
  try? createAssetFolder(at: appIconAssetParentDirUrl)
  
  imageSetSpeculidUrl = speculidDirUrl.appendingPathComponent(svgName).appendingPathExtension("image-set").appendingPathExtension("speculid")
  
  appIconSpeculidUrl = speculidDirUrl.appendingPathComponent(svgName).appendingPathExtension("app-icon").appendingPathExtension("speculid")
  
  imageSetAssetDirUrl = imageSetAssetParentDirUrl.appendingPathComponent(svgName + ".imageset")
  appIconAssetDirUrl = appIconAssetParentDirUrl.appendingPathComponent(svgName + ".appiconset")
  
  let appIconSpecText = """
  {
  "set" : "\(appIconAssetDirUrl.relativePath(from: appIconSpeculidUrl)!)",
  "source" : "\(svgUrl.relativePath(from: appIconSpeculidUrl)!)",
  "background" : "#FFFFFF",
  "remove-alpha" : true
  }
  """
  
  let imageSetSpecText = """
  {
  "set" : "\(imageSetAssetDirUrl.relativePath(from: imageSetSpeculidUrl)!)",
  "source" : "\(svgUrl.relativePath(from: imageSetSpeculidUrl)!)"
  }
  """
  
  do {
    try appIconSpecText.write(to: appIconSpeculidUrl, atomically: true, encoding: .utf8)
    try imageSetSpecText.write(to: imageSetSpeculidUrl, atomically: true, encoding: .utf8)
    
    try FileManager.default.createDirectory(at: imageSetAssetDirUrl, withIntermediateDirectories: true)
    try FileManager.default.createDirectory(at: appIconAssetDirUrl, withIntermediateDirectories: true)
    
    try imageSetJsonData.write(to: imageSetAssetDirUrl.appendingPathComponent("Contents.json"))
    try appIconJsonData.write(to: appIconAssetDirUrl.appendingPathComponent("Contents.json"))
  } catch {
    completed(error)
    return
  }
  
  completed(nil)
}

func download(_ name: String, from url: URL, relativeSVGPath: String) -> Promise<Void> {
  let promise = firstly {
    Promise<URL> { resolver in
      URLSession.shared.downloadTask(with: url) {
        resolver.resolve($0, $2)
      }.resume()
    }
  }.then { url in
    Promise<URL> { resolver in
      let unzipDirUrl = graphicsUrl.appendingPathComponent(name)
      do {
        try FileManager.default.createDirectory(at: unzipDirUrl, withIntermediateDirectories: true)
        try FileManager.default.unzipItem(at: url, to: unzipDirUrl)
      } catch {
        resolver.reject(error)
      }
      resolver.fulfill(unzipDirUrl)
    }
  }.map { (dirUrl) throws -> (URL, [URL]) in
    let svgDirectoryUrl = dirUrl.appendingPathComponent(relativeSVGPath)
    guard let enumerator = FileManager.default.enumerator(at: svgDirectoryUrl, includingPropertiesForKeys: nil) else {
      throw NSError()
    }
    return (svgDirectoryUrl, enumerator.compactMap { $0 as? URL }.filter {
      $0.pathExtension == "svg"
    })
  }.then { (svgDirectoryUrl, urls) -> Promise<Void> in
    
    let promises: [Promise<Void>] = urls.map {
      svgUrl in
      Promise<Void> { resolver in
        setup(svgUrl: svgUrl, relativeTo: svgDirectoryUrl, withName: name) {
          resolver.resolve($0)
        }
      }
    }
    return when(fulfilled: promises)
  }
  return promise
}

//swiftlint:disable line_length
let appiconCompressed = "/Td6WFoAAAD/EtlBAgAhARYAAAB0L+Wj4A/PAildAD2IiScTleJp4I3wK/qYuY+Q19WElc6w3zOWoXmUZxfss8ijNG8Vq2i9AdIyvN9cU1rQmMdrXAC2orQ3kyyb0BJo8+Ro1epyzZhvRhZJfDJ4nzxJa466P+vtAVP6tpB0nD4+krz6y6a25Zci6vVgZIwVXy7c1I0lHOsY06z9m72gQyV/J8y39C/wW7hG3q06VyT0EFi2YcK5HQLiCGT2CAWvgv+9VS5nBs5TEAi17QOYk8U03t5kqKHxPRXDEa+tTQp8nVrak8zMZmRrAHQNx32X04rOYd14G5n4a9yLyO08hFNBnISIdzmc1icg0XGR217sTtcn+Q3Wb0J0gGFkq8E0EWW7FhLle3Gv7P2F4GyMwGFsGBhLxAZf4sYCl4GDII7pZxnzf3yN6YDmXnUYvRrJdQy68j8rsB6AyYVOZG1Y8jdl9TQrxZFo9wVR+yr2MvhXbfIIXyzHBn7aeLyoWMmdtEVUda+kNhiVJSjDyC7QLstG6DqqDBGTe71FK4+OnAma1tdU4jmajQ+KmniTgIlpjWLk7xahFHOnRtiG6xWnZImuAeQxt1z2VyNC2kD4hEnwVErnO+pjsh+fnovbPBE/FcPP5NMUkomNBq3H0E+ibppLd7rW0QTz88eaqZkz/GARIB1ES5IufHmezsC/+vK19iPRoKyHxBrgnTSnw351wNLLNk2TH1Kq4HaJQn0kJnj6XJhUhf6/8VewSBomM3OjOSck2FfidOwAAAAAAAG9BNAfAABiL6+hqAAK/AIAAAAAAFla"

let imageSetCompressed = "/Td6WFoAAAD/EtlBAgAhARYAAAB0L+Wj4AFSAJJdAD2IiScTleJp4I3wK/x+Mze2nB5KXcVj7OoMqFZvgFGCE7wldKHUpccmFrXNLK1uhdeDtypNu7v7FUrpI1ZupEmS/Zs0P8h5rpvoIEQDaUgpgi73f/GyQvY+uJDRfDGqumTyUN+zG9GFZQT6Xll/Re2S7TRajnPrtiHj6yGO/A9sXbhRT8y73oiV5mnkEYe9QnUAAAAAAAGmAdMCAACHzRUGqAAK/AIAAAAAAFla"
//swiftlint:enable line_length

let folderContentsJson = """
{
"info" : {
"version" : 1,
"author" : "xcode"
}
}
"""


let exampleUrl = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()

let sampleUrl = exampleUrl.appendingPathComponent("sample")

if FileManager.default.fileExists(atPath: sampleUrl.path) {
  try FileManager.default.removeItem(at: sampleUrl)
}

let graphicsUrl = sampleUrl.appendingPathComponent("graphics")
let assetsUrl = sampleUrl.appendingPathComponent("Assets.xcassets")
let speculidUrl = sampleUrl.appendingPathComponent("speculid")

let imageSetsUrl = assetsUrl.appendingPathComponent("Image Sets")
let appIconsUrl = assetsUrl.appendingPathComponent("App Icons")

//swiftlint:disable force_try
let appIconJsonData = try! uncompressedString(fromCompressedBase64: appiconCompressed)
let imageSetJsonData = try! uncompressedString(fromCompressedBase64: imageSetCompressed)

try! FileManager.default.createDirectory(at: graphicsUrl, withIntermediateDirectories: true)

try! createAssetFolder(at: imageSetsUrl)
try! createAssetFolder(at: appIconsUrl)

try! FileManager.default.createDirectory(at: speculidUrl, withIntermediateDirectories: true)
//swiftlint:enable force_try

when(fulfilled: [
  download("fontawesome",
           from: URL(string: "https://use.fontawesome.com/releases/v5.13.0/fontawesome-free-5.13.0-desktop.zip")!,
           relativeSVGPath: "fontawesome-free-5.13.0-desktop/svgs"),
  download("mfizz",
           from: URL(string: "https://github.com/fizzed/font-mfizz/archive/v2.4.1.zip")!,
           relativeSVGPath: "font-mfizz-2.4.1/src/svg")
]).done {
  shouldKeepRunning = false
}.catch { error in
  print(error)
  exit(1)
}

var shouldKeepRunning = true

while RunLoop.current.run(mode: .default, before: .distantFuture), shouldKeepRunning {}
