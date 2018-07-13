import Foundation

public struct RegularExpressionSet: RegularExpressionSetProtocol {
  public func regularExpression(for key: RegularExpressionKey) -> NSRegularExpression! {
    return dictionary[key]
  }

  public let dictionary: [RegularExpressionKey: NSRegularExpression]
}
