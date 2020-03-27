import Foundation

public struct InstallType: OptionSet {
  public let rawValue: UInt8

  public static let command = InstallType(rawValue: 1 << 0)

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }

  public static let all: InstallType = [.command]
}
