import Foundation

public struct SpeculidApplicationModeParser: SpeculidApplicationModeParserProtocol {
  public func parseMode(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidApplicationMode {
    var indicies = [Int]()
    if commandLine.arguments.first == Bundle.main.executablePath {
      indicies.append(commandLine.arguments.startIndex)
    }
    if let index = commandLine.arguments.index(of: "-NSDocumentRevisionsDebugMode") {
      indicies.append(index)
      indicies.append(index.advanced(by: 1))
    }
    let arguments = indicies.sorted().reversed().reduce(commandLine.arguments) { (arguments, index) -> [String] in
      var arguments = arguments
      arguments.remove(at: index)
      return arguments
    }
    if arguments.count > 0 {
      if arguments.contains("--help") {
        return .command(.help)
      } else if arguments.contains("--version") {
        return .command(.version)
      } else if let index = arguments.firstIndex(of: "--process") {
        let filePath = arguments[arguments.index(after: index)]
        if FileManager.default.fileExists(atPath: filePath) {
          return .command(.process(URL(fileURLWithPath: filePath)))
        } else {
          return .command(.unknown(commandLine.arguments))
        }
      } else {
        return .command(.unknown(commandLine.arguments))
      }
    } else {
      return .cocoa
    }
  }
}
