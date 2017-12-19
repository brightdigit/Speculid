import Foundation

public enum SpeculidApplicationMode: Equatable {
  public static func == (lhs: SpeculidApplicationMode, rhs: SpeculidApplicationMode) -> Bool {
    switch (lhs, rhs) {
    case (.cocoa, .cocoa): return true
    case let (.command(l), .command(r)): return l == r
    default: return false
    }
  }

  case command(SpeculidCommandArgumentSet)
  case cocoa
}
