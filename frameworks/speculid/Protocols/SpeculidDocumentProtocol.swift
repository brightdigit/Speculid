public protocol SpeculidDocumentProtocol {
  var specifications: SpeculidSpecificationsFileProtocol { get }
  var images: [AssetSpecificationProtocol] { get }
}
