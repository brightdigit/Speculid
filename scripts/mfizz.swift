// swiftlint:disable all
import Cocoa

struct LCGroupIcon : Codable {
  let iconName : String?
  let iconSet : String?
}

let mfizzPath = "/Users/leo/Documents/Projects/lansingcodes-iOS-app/graphics/mfizz"
let mfizzURL = URL(fileURLWithPath: mfizzPath, isDirectory: true)
let svgsURL = mfizzURL.appendingPathComponent("svgs")
let speculidDirURL = mfizzURL.appendingPathComponent("speculid")
let imageSetPath = URL(fileURLWithPath: "/Users/leo/Documents/Projects/lansingcodes-iOS-app/lansingcodes-iOS-app/Image.imageset", isDirectory: true)
let destinationFolder = URL(fileURLWithPath: "/Users/leo/Documents/Projects/lansingcodes-iOS-app/lansingcodes-iOS-app/Assets.xcassets/Group Icons", isDirectory: true)
if FileManager.default.fileExists(atPath: speculidDirURL.path) {
  try! FileManager.default.removeItem(at: speculidDirURL)
  
}
try! FileManager.default.createDirectory(at: speculidDirURL, withIntermediateDirectories: true, attributes: nil)
let speculidContents = """
{
  "set" : "../../../lansingcodes-iOS-app/Assets.xcassets/Group Icons/%@.imageset",
  "source" : "../svgs/%@",
  "geometry" : "32"
}
"""
let files = try! FileManager.default.contentsOfDirectory(at: svgsURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())

for file in files {
  guard file.pathExtension == "svg" else {
    continue
  }
  let fullName = "mfizz."+file.deletingPathExtension().lastPathComponent
  let speculidJSON = String(format: speculidContents, fullName, file.lastPathComponent)

  try? FileManager.default.copyItem(at: imageSetPath, to: destinationFolder.appendingPathComponent(fullName).appendingPathExtension("imageset"))
  try! speculidJSON.write(to: speculidDirURL.appendingPathComponent(fullName).appendingPathExtension("speculid"), atomically: true, encoding: .utf8)
}


