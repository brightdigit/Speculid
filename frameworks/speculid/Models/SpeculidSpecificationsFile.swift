import AppKit
import CairoSVG
import Foundation

extension URL {
  func relativePath(from base: URL) -> String? {
    // Ensure that both URLs represent files:
    guard isFileURL, base.isFileURL else {
      return nil
    }

    // Remove/replace "." and "..", make paths absolute:
    let destComponents = standardized.pathComponents
    let baseComponents = base.standardized.pathComponents

    // Find number of common path components:
    var index = 0
    while index < destComponents.count, index < baseComponents.count,
      destComponents[index] == baseComponents[index] {
      index += 1
    }

    // Build relative path:
    var relComponents = Array(repeating: "..", count: baseComponents.count - index - 1)
    relComponents.append(contentsOf: destComponents[index...])
    return relComponents.joined(separator: "/")
  }
}

public struct SpeculidSpecificationsFile: SpeculidSpecificationsFileProtocol, Codable {
  public let assetDirectoryRelativePath: String
  public let sourceImageRelativePath: String
  public let geometry: GeometryDimension?
  public let background: NSColor?
  public let removeAlpha: Bool

  public enum CodingKeys: String, CodingKey {
    case assetDirectoryRelativePath = "set"
    case sourceImageRelativePath = "source"
    case geometry
    case background
    case removeAlpha = "remove-alpha"
  }

  public init(assetURL: URL, sourceImageURL: URL, destinationURL: URL) {
    let actualAssetURL: URL
    if assetURL.pathExtension.lowercased() == "json" {
      actualAssetURL = assetURL.deletingLastPathComponent()
    } else {
      actualAssetURL = assetURL
    }
    assetDirectoryRelativePath = actualAssetURL.relativePath(from: destinationURL) ?? actualAssetURL.path
    sourceImageRelativePath = sourceImageURL.relativePath(from: destinationURL) ?? sourceImageURL.path
    geometry = nil
    background = nil
    removeAlpha = actualAssetURL.pathExtension.lowercased() == "appiconset"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    assetDirectoryRelativePath = try container.decode(String.self, forKey: CodingKeys.assetDirectoryRelativePath)
    sourceImageRelativePath = try container.decode(String.self, forKey: CodingKeys.sourceImageRelativePath)
    removeAlpha = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.removeAlpha) ?? false

    let geometry: GeometryDimension?

    if let geometryString = try container.decodeIfPresent(String.self, forKey: CodingKeys.geometry) {
      geometry = try GeometryDimension(string: geometryString)
    } else {
      geometry = nil
    }

    let background: NSColor?
    if let colorString = try container.decodeIfPresent(String.self, forKey: CodingKeys.background) {
      background = try NSColor(rgba_throws: colorString)
    } else {
      background = nil
    }

    self.background = background
    self.geometry = geometry
  }

  public func encode(to encoder: Encoder) throws {
    var container = try encoder.container(keyedBy: CodingKeys.self)

    try container.encode(assetDirectoryRelativePath, forKey: CodingKeys.assetDirectoryRelativePath)
    try container.encode(sourceImageRelativePath, forKey: CodingKeys.sourceImageRelativePath)
    try container.encode(geometry, forKey: CodingKeys.geometry)
    try container.encode(removeAlpha, forKey: CodingKeys.removeAlpha)
    try container.encode(background?.hexString(), forKey: CodingKeys.background)
  }

  //
  //  public init(assetSetRelativePath: String,
  //              sourceImageRelativePath: URL,
  //              geometry: Geometry? = nil,
  //              background: NSColor? = nil,
  //              removeAlpha: Bool = false) {
  //    self.contentsDirectoryURL = contentsDirectoryURL
  //    self.geometry = geometry
  //    self.sourceImageURL = sourceImageURL
  //    self.background = background
  //    self.removeAlpha = removeAlpha
  //  }
  //
  //  public init?(url: URL) {
  //    let geometry: Geometry?
  //    let background: NSColor?
  //
  //    guard let data = try? Data(contentsOf: url) else {
  //      return nil
  //    }
  //
  //    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
  //      return nil
  //    }
  //
  //    guard let dictionary = json as? [String: Any] else {
  //      return nil
  //    }
  //
  //    guard let setRelativePath = dictionary["set"] as? String, let sourceRelativePath = dictionary["source"] as? String else {
  //      return nil
  //    }
  //
  //    if let backgroundString = dictionary["background"] as? String {
  //      background = NSColor(backgroundString)
  //    } else {
  //      background = nil
  //    }
  //
  //    if let geometryString = dictionary["geometry"] as? String {
  //      geometry = Geometry(string: geometryString)
  //    } else {
  //      geometry = nil
  //    }
  //
  //    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
  //
  //    let sourceImageURL = url.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
  //
  //    contentsDirectoryURL = contentsJSONURL.deletingLastPathComponent()
  //    self.sourceImageURL = sourceImageURL
  //    self.geometry = geometry
  //    self.background = background
  //    removeAlpha = dictionary["remove-alpha"] as? Bool ?? false
  //  }
}
