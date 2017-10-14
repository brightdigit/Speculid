import Foundation

public struct ProcessError: Error, CustomStringConvertible {
  public let process: Process
  public let message: String

  public var localizedDescription: String {
    return message
  }

  public var description: String {
    return message
  }
}
