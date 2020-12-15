import Foundation

public protocol SpeculidConfigurationBuilderProtocol {
  func configuration(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidConfigurationProtocol
}
