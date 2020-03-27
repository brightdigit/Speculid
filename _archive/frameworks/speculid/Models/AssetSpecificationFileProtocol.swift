import Foundation

public protocol AssetSpecificationFileProtocol {
  var url: URL { get }
  var document: AssetSpecificationDocumentProtocol { get }
}
