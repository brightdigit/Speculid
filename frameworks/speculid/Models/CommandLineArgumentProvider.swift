import Foundation

public struct CommandLineArgumentProvider: CommandLineArgumentProviderProtocol {
  public let commandLine: CommandLine.Type

  public init(commandLine: CommandLine.Type? = nil) {
    self.commandLine = commandLine ?? CommandLine.self
  }

  public var arguments: [String] {
    return commandLine.arguments
  }
}
