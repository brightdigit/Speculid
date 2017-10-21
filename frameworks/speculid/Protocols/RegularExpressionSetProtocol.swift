import Foundation

public enum RegularExpressionKey: Int {
  case geometry
  case integer
  case scale
  case size
  case number
}

public protocol RegularExpressionSetProtocol {
  func regularExpression(for key: RegularExpressionKey) -> NSRegularExpression!
}
