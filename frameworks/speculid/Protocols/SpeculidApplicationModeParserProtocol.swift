import Foundation

public protocol SpeculidApplicationModeParserProtocol {
  func parseMode(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidApplicationMode
}
