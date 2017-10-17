public protocol ImageConversionBuilderProtocol {
  func conversion(
    forImage imageSpecification: AssetSpecificationProtocol,
    withSpecifications specifications: SpeculidSpecificationsProtocol,
    andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult?
}
