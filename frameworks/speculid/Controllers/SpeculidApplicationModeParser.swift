import Foundation

public struct SpeculidApplicationModeParser: SpeculidApplicationModeParserProtocol {
  public func parseMode(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidApplicationMode {
    if commandLine.arguments.count > 0 {
      if commandLine.arguments.contains("-help") {
        return .command(.help)
      } else if commandLine.arguments.contains("-version") {
        return .command(.version)
      } else {
        for argument in commandLine.arguments[1...] {
          if FileManager.default.fileExists(atPath: argument) {
            return .command(.file(URL(fileURLWithPath: argument)))
          }
        }
        return .command(.unknown(commandLine.arguments))
      }
    } else {
      return .cocoa
    }
  }
}
