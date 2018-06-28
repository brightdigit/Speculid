import Foundation

public protocol SpeculidImageSpecificationBuilderProtocol {
  func imageSpecification(
    forURL destinationURL: URL,
    withSpecifications specifications: SpeculidSpecificationsFileProtocol,
    andAsset asset: AssetSpecificationProtocol) throws -> ImageSpecification
}
