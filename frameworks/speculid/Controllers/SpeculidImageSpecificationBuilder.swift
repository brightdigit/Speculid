import Foundation

@available(*, deprecated: 2.0.0)
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

    let geometryObj: GeometryProtocol?

    if let size = asset.size {
      geometryObj = try Geometry(size: size, preferWidth: true).scaling(by: asset.scale)
    } else if let specificationsGeomtetry = specifications.geometry {
      geometryObj = specificationsGeomtetry.scaling(by: asset.scale)
    } else if let scale = asset.scale {
      geometryObj = Geometry(value: .scale(scale))
    } else {
      geometryObj = nil
    }

    let geometry: Geometry?
    if let geometryValue = geometryObj?.value {
      geometry = Geometry(value: geometryValue)
    } else {
      geometry = nil
    }

    return ImageSpecification(
      file: destinationFile,
      geometryDimension: geometry,
      removeAlphaChannel: specifications.removeAlpha,
      backgroundColor: specifications.background)
  }
}
