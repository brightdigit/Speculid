import Foundation

public protocol RegularExpressionSetBuilderProtocol {
  func buildRegularExpressions(fromDictionary dictionary: [RegularExpressionKey: RegularExpressionArgumentSet]) throws -> RegularExpressionSetProtocol
}
