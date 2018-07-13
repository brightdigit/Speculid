import Foundation

public enum SpeculidApplicationMode: Equatable {
  public static func == (lhs: SpeculidApplicationMode, rhs: SpeculidApplicationMode) -> Bool {
    switch (lhs, rhs) {
    case (.cocoa, .cocoa): return true
    case let (.command(left), .command(right)): return left == right
    default: return false
    }
  }

  case command(SpeculidCommandArgumentSet)
  case cocoa
}
