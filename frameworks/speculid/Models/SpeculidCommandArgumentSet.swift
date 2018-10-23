import Foundation

public enum SpeculidCommandArgumentSet: Equatable {
  public static func == (lhs: SpeculidCommandArgumentSet, rhs: SpeculidCommandArgumentSet) -> Bool {
    switch (lhs, rhs) {
    case (.help, .help): return true
    case (.unknown, .unknown): return true
    case (.version, .version): return true
    case let (.process(left), .process(right)): return left == right
    default: return false
    }
  }

  case help
  case unknown([String])
  case version
  case process(URL)
  case install(InstallType)
  case debugLocation
}
