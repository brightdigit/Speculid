import Foundation

public struct AssetSpecificationMetadata: AssetSpecificationMetadataProtocol {
  public static let defaultAuthor = Application.author
  public let author: String // = Application.bundle.bundleIdentifier!
  public let version: Int // = 1

  init(author: String = AssetSpecificationMetadata.defaultAuthor, version: Int = 1) {
    self.author = author
    self.version = version
  }
}

extension AssetSpecificationMetadata {
  init(_ metadata: AssetSpecificationMetadataProtocol) {
    author = metadata.author
    version = metadata.version
  }
}
