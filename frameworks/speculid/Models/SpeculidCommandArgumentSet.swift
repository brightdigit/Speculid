import Foundation

public enum SpeculidCommandArgumentSet: Equatable {
  public static func == (lhs: SpeculidCommandArgumentSet, rhs: SpeculidCommandArgumentSet) -> Bool {
    switch (lhs, rhs) {
    case (.help, .help): return true
    case (.unknown, .unknown): return true
    case (.version, .version): return true
    case let (.file(left), .file(right)): return left == right
    default: return false
    }
  }

  case help
  // swiftlint:disable:next identifier_name
  case unknown([String])
  case version
  // swiftlint:disable:next identifier_name
  case file(URL)
}
