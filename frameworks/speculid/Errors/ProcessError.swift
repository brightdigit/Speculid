import Foundation

public struct ProcessError: Error, CustomStringConvertible {
  public let process: Process
  public let message: String

  public var localizedDescription: String {
    message
  }

  public var description: String {
    message
  }
}
