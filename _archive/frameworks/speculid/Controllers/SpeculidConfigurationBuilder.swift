import Foundation

public struct SpeculidConfigurationBuilder: SpeculidConfigurationBuilderProtocol {
  public let applicationModeParser: SpeculidApplicationModeParserProtocol

  public func configuration(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidConfigurationProtocol {
    let mode = applicationModeParser.parseMode(fromCommandLine: commandLine)
    return SpeculidConfiguration(mode: mode)
  }

  public init(applicationModeParser: SpeculidApplicationModeParserProtocol? = nil, coder _: NSCoder? = nil) {
    self.applicationModeParser = applicationModeParser ?? SpeculidApplicationModeParser()
  }
}
