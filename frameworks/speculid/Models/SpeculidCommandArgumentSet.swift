import Foundation

public enum SpeculidCommandArgumentSet: Equatable {
  public static func == (lhs: SpeculidCommandArgumentSet, rhs: SpeculidCommandArgumentSet) -> Bool {
    switch (lhs, rhs) {
    case (.help, .help): return true
    case (.unknown, .unknown): return true
    case (.version, .version): return true
    case let (.file(l), .file(r)): return l == r
    default: return false
    }
  }

  case help
  case unknown([String])
  case version
  case file(URL)
}
