import Foundation

public enum RegularExpressionKey {}

public typealias RegularExpressionParameters = (String, NSRegularExpression.Options)

public struct RegularExpressions {
  public let dictionary: [RegularExpressionKey: NSRegularExpression]

  public init(dictionary _: [RegularExpressionKey: RegularExpressionParameters]) {}
}
