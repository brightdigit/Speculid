@available(*, deprecated: 2.0.0)
public protocol ImageConversionBuilderProtocol {
  func conversion(
    forImage imageSpecification: AssetSpecificationProtocol,
    withSpecifications specifications: SpeculidSpecificationsFileProtocol,
    andConfiguration configuration: SpeculidConfigurationProtocol) -> Result<ImageConversionTaskProtocol>?
}
