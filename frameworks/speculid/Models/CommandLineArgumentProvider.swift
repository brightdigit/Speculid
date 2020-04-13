import Foundation

public struct CommandLineArgumentProvider: CommandLineArgumentProviderProtocol {
  public let commandLine: CommandLine.Type
  public let environment: [String: String]

  public init(commandLine: CommandLine.Type? = nil, environment: [String: String]? = nil) {
    self.commandLine = commandLine ?? CommandLine.self
    self.environment = environment ?? ProcessInfo.processInfo.environment
  }

  public var arguments: [String] {
    commandLine.arguments
  }
}
