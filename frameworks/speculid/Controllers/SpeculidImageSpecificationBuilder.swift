import Foundation

public struct NoGeometrySpecifiedError: Error {
  public let asset: AssetSpecificationProtocol
  public let specification: SpeculidSpecificationsFileProtocol

  public init(forAsset asset: AssetSpecificationProtocol, withSpecs specification: SpeculidSpecificationsFileProtocol) {
    self.asset = asset
    self.specification = specification
  }
}
public struct SpeculidImageSpecificationBuilder: SpeculidImageSpecificationBuilderProtocol {
  public func imageSpecification(
    forURL destinationURL: URL,
    withSpecifications specifications: SpeculidSpecificationsFileProtocol,
    andAsset asset: AssetSpecificationProtocol) throws -> ImageSpecification {
    let destinationFile = try ImageFile(url: destinationURL)

    let geometry: GeometryProtocol

    if let size = asset.size {
      geometry = try Geometry(size: size, preferWidth: true).scaling(by: asset.scale)
    } else if let specificationsGeomtetry = specifications.geometry {
      geometry = specificationsGeomtetry.scaling(by: asset.scale)
    } else {
      throw NoGeometrySpecifiedError(forAsset: asset, withSpecs: specifications)
    }

    return ImageSpecification(
      file: destinationFile,
      geometryDimension: Geometry(value: geometry.value),
      removeAlphaChannel: specifications.removeAlpha,
      backgroundColor: specifications.background)
  }
}
