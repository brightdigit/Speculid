public protocol ImageConversionBuilderProtocol {
  func conversion(
    forImage imageSpecification: AssetSpecificationProtocol,
    withSpecifications specifications: SpeculidSpecificationsFileProtocol,
    andConfiguration configuration: SpeculidConfigurationProtocol) -> Result<ImageConversionTaskProtocol>?
}
