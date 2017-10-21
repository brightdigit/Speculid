import Foundation

public struct ImageConversionBuilder: ImageConversionBuilderProtocol {
  public static let defaultBuilders: [ImageConversionBuilderProtocol] = []
  public static let sharedInstance: ImageConversionBuilderProtocol = ImageConversionBuilder()

  public let builders: [ImageConversionBuilderProtocol]

  public func conversion(
    forImage imageSpecification: AssetSpecificationProtocol,
    withSpecifications specifications: SpeculidSpecificationsProtocol,
    andConfiguration configuration: SpeculidConfigurationProtocol) -> Result<ImageConversionTaskProtocol>? {
    for builders in builders {
      if let conversion = builders.conversion(
        forImage: imageSpecification,
        withSpecifications: specifications,
        andConfiguration: configuration) {
        return conversion
      }
    }
    return nil
  }

  public init(builders: [ImageConversionBuilderProtocol]? = nil) {
    self.builders = builders ?? ImageConversionBuilder.defaultBuilders
  }
}
