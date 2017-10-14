import Foundation

public protocol ImageConversionSetBuilderProtocol {
  func buildConversions(forDocument document: SpeculidDocumentProtocol, withConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionSetProtocol?
}
