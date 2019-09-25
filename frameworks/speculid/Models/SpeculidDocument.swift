import Foundation

public struct SpeculidDocument: SpeculidDocumentProtocol {
  public let url: URL
  public let specificationsFile: SpeculidSpecificationsFileProtocol
  // public let asset: AssetSpecificationDocumentProtocol
  public let assetFile: AssetSpecificationFileProtocol

  public init(url: URL, decoder: JSONDecoder, configuration _: SpeculidConfigurationProtocol? = nil) throws {
    let specificationsFileData = try Data(contentsOf: url)
    let specificationsFile = try decoder.decode(SpeculidSpecificationsFile.self, from: specificationsFileData)

    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(specificationsFile.assetDirectoryRelativePath, isDirectory: true).appendingPathComponent("Contents.json")

    let assetData = try Data(contentsOf: contentsJSONURL)
    let asset = try decoder.decode(AssetSpecificationDocument.self, from: assetData)

    self.specificationsFile = specificationsFile
    assetFile = AssetSpecificationFile(url: contentsJSONURL, document: asset)
    self.url = url
  }
}
