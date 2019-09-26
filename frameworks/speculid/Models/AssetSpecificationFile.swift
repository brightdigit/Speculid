import Foundation

public struct AssetSpecificationFile: AssetSpecificationFileProtocol {
  public let url: URL
  public let document: AssetSpecificationDocumentProtocol
}
