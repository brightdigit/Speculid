import Foundation

@objc
public protocol ServiceProtocol {
  func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback: @escaping ((NSError?) -> Void))
  func updateAssetCatalogAtURL(_ url: URL, withItems items: [AssetCatalogItem], _ callback: @escaping ((NSError?) -> Void))
}
