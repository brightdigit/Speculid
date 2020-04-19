//
//  main.swift
//  TestSetup
//
//  Created by Leo Dion on 4/18/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

import Foundation
import ZIPFoundation // @weichsel ~> 0.9.0
import PromiseKit // @mxcl ~> 6.5

let appiconCompressed = "UEsDBC0ACAAIAMxxk1AAAAAA//////////8BABQALQEAEAAAAAAAAAAAAAAAAAAAAAAArZVBc5swEIXv/Rk6uwwIgbFPmek1txw7PSggg8YGURCtUo/72yvJ2HUcwCvCAWaM337vsSzLEfGS5qxF2+9H1PI/DG0R9hX20QrxjItS/+Z1ISqmL+z4gVW0NJqciZLJ5s2z4ies/p5VXl3lWtmm9GBRCp1WnwGHI+DwPXij8AYMNmJoYncwLDHxFQG3woqBiWeAYYljX8VgsBUDE88AA6fiw7jRbHLYAoOl2R00+BwUD0Ifjdk41A4ZKKkrFJL043iNQs/DBUnqDIUkXcdqHcOgVgpK6gyFJE1CL1LmBANf5SB44GOizOkWLtqvJW32THJbOeRyrbN9uS2YbND9y5zS5tGK0BKn/fAIGQ4h7zYDUbYhjbB/VkLyHU+p5KL6xirJxgxsncn8m8q06C0uuew1Y9m9yrfamiZlOf7Or/VjNKc5OS618CwET2W5WxWX8sldcevb30AqyppWOv0Lk2ZU2gUdQ2fH4S9uX0jr+pl2VVqMNvm6ahZ42IQoQpzMTYHD0/UnzCNfRU53bgsczMmEeRKrJP5v/rPj6f5ZiP3YcjPyhZq+SdQmgVtb+UIvVOAnenk6mPcFCzV9aOlbhNvavyuZXPxBrILbL2NJ0zELozR4LVkUiYeQ7xsTYhViENIqISldkYCUAdbDgBPYrZ+1oH7OwALS4ihW+gBhey0k7RwsIG0UYKUPELbXQtLOwY6m/aEp1U6g7RH9Yk2rv25oG6wQ7WQhmvNHz3tteF7IjOdcei81S7sDz9Dp9OUfUEsHCDnZLI1AAgAAAAAAANEPAAAAAAAAUEsBAh4DLQAIAAgAzHGTUDnZLI1AAgAA0Q8AAAEAAAAAAAAAAQAAALARAAAAAC1QSwUGAAAAAAEAAQAvAAAAiwIAAAAA"

let imageSetCompressed = "UEsDBC0ACAAIAANsk1AAAAAA//////////8BABQALQEAEAAAAAAAAAAAAAAAAAAAAAAAlc3LCsIwEIXhvY9x1iXQdpfXcCkuYjNJB3IpaSqVUJ/ddCOCFHT7z+GbAvbK0gx5KWDN0UNiCXynNCuHBoYdBeWpZkvRU04PMWmDrSmYB+X2Q7seDNv1+bbEFGydff/4lLojqftX6o+k/ifpWmswEbJgTxwDZNtALXmMqU6H6MUtsR2zZstZnCcaFsca23Z6AVBLBwhwptLSkQAAAAAAAABUAQAAAAAAAFBLAQIeAy0ACAAIAANsk1BwptLSkQAAAFQBAAABAAAAAAAAAAEAAACwEQAAAAAtUEsFBgAAAAABAAEALwAAANwAAAAAAA=="


let folderContentsJson = """
{
"info" : {
"version" : 1,
"author" : "xcode"
}
}
"""

func uncompressedString(fromCompressedBase64 compressedBase64String: String) throws -> Data? {

  guard let data = Data(base64Encoded: compressedBase64String) else {
    return nil
  }
  
//  let nsData = data as NSData
//
//  let decompressedNsData : NSData
//  do {
//    decompressedNsData = try nsData.decompressed(using: .lzma)
//  } catch let error as NSError {
//    dump(error)
//  throw error
//  }
//
//  return decompressedNsData as Data
  
  let tempZipFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
  let tempFolderURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

  try data.write(to: tempZipFileURL)
  try FileManager.default.createDirectory(at: tempFolderURL, withIntermediateDirectories: false)
  try FileManager.default.unzipItem(at: tempZipFileURL, to: tempFolderURL)
  let files = try FileManager.default.contentsOfDirectory(at: tempFolderURL, includingPropertiesForKeys: nil)

  guard let url = files.first else {
    return nil
  }

  return try Data(contentsOf: url)
}

//let appIconDataTEmp = try uncompressedString(fromCompressedBase64: appiconCompressed)
extension URL {
    func relativePath(from base: URL) -> String? {
        // Ensure that both URLs represent files:
        guard self.isFileURL && base.isFileURL else {
            return nil
        }

        //this is the new part, clearly, need to use workBase in lower part
        var workBase = base
        if workBase.pathExtension != "" {
            workBase = workBase.deletingLastPathComponent()
        }

        // Remove/replace "." and "..", make paths absolute:
        let destComponents = self.standardized.resolvingSymlinksInPath().pathComponents
        let baseComponents = workBase.standardized.resolvingSymlinksInPath().pathComponents

        // Find number of common path components:
        var i = 0
        while i < destComponents.count &&
              i < baseComponents.count &&
              destComponents[i] == baseComponents[i] {
                i += 1
        }

        // Build relative path:
        var relComponents = Array(repeating: "..", count: baseComponents.count - i)
        relComponents.append(contentsOf: destComponents[i...])
        return relComponents.joined(separator: "/")
    }
}

var shouldKeepRunning = true

func createAssetFolder(at url: URL) throws {
  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
  let fileUrl = url.appendingPathComponent("Contents.json")
  try folderContentsJson.write(to: fileUrl, atomically: true, encoding: .utf8)
}

let appIconJsonData = try! Data(contentsOf: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("AppIcon.json"))
let imageSetJsonData = try! Data(contentsOf: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("ImageSet.json"))
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

try! FileManager.default.createDirectory(at: graphicsUrl, withIntermediateDirectories: true)

try! createAssetFolder(at: imageSetsUrl)
try! createAssetFolder(at: appIconsUrl)

try! FileManager.default.createDirectory(at: speculidUrl, withIntermediateDirectories: true)


func download(_ name: String, from url: URL, relativeSVGPath: String) -> Promise<Void> {
  let promise = firstly {
    Promise<URL>{ (resolver) in
      URLSession.shared.downloadTask(with: url) {
        resolver.resolve($0, $2)
      }.resume()
    }
  }.then { (url) in
    return Promise<URL>{ (resolver) in
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
    return (svgDirectoryUrl, enumerator.compactMap{ $0 as? URL }.filter{
      $0.pathExtension == "svg"
    })
  }.then { (svgDirectoryUrl, urls) -> Promise<Void> in
    
    let promises : [Promise<Void>] = urls.map {
      (svgUrl) in
      return Promise<Void>{ (resolver) in
        guard let parentPath = svgUrl.deletingLastPathComponent().relativePath(from: svgDirectoryUrl) else {
          resolver.reject(NSError())
          return
        }
        
        let imageSetSpeculidUrl : URL
        let appIconSpeculidUrl : URL
        let imageSetAssetDirUrl : URL
        let appIconAssetDirUrl : URL
        
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
        
        try appIconSpecText.write(to: appIconSpeculidUrl, atomically: true, encoding: .utf8)
        try imageSetSpecText.write(to: imageSetSpeculidUrl, atomically: true, encoding: .utf8)
        
        try FileManager.default.createDirectory(at: imageSetAssetDirUrl, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: appIconAssetDirUrl, withIntermediateDirectories: true)
        
        try imageSetJsonData.write(to: imageSetAssetDirUrl.appendingPathComponent("Contents.json"))
        try appIconJsonData.write(to: appIconAssetDirUrl.appendingPathComponent("Contents.json"))
        resolver.fulfill(())
      }
    }
    return when(fulfilled: promises)
  }
  return promise
}

let fontAwesome = download("fontawesome", from: URL(string: "https://use.fontawesome.com/releases/v5.13.0/fontawesome-free-5.13.0-desktop.zip")!, relativeSVGPath: "fontawesome-free-5.13.0-desktop/svgs")

let promise = download("mfizz", from: URL(string: "https://github.com/fizzed/font-mfizz/archive/v2.4.1.zip")!, relativeSVGPath: "font-mfizz-2.4.1/src/svg")


when(fulfilled: [promise, fontAwesome]).done({
  shouldKeepRunning = false
}).catch { (error) in
  print(error)
  exit(1)
}


while RunLoop.current.run(mode: .default, before: .distantFuture) && shouldKeepRunning {}
