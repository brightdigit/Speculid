import Foundation

public struct RegularExpressionSetBuilder: RegularExpressionSetBuilderProtocol {
  public func buildRegularExpressions(fromDictionary dictionary: [RegularExpressionKey: RegularExpressionArgumentSet]) throws -> RegularExpressionSetProtocol {
    let values = try dictionary.reduce([RegularExpressionKey: NSRegularExpression]()) { (values, arguments) -> [RegularExpressionKey: NSRegularExpression] in
      var values = values
      let regularExpression = try NSRegularExpression(pattern: arguments.value.0, options: arguments.value.1)
      values[arguments.key] = regularExpression
      return values
    }

    return RegularExpressionSet(dictionary: values)
  }
}
