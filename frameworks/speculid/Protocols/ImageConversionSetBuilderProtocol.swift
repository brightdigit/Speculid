import Foundation

@available(*, deprecated: 2.0.0)
public protocol ImageConversionSetBuilderProtocol {
  func buildConversions(forDocument document: SpeculidDocumentProtocol, withConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionSetProtocol?
}
