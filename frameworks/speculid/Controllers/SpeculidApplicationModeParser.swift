import Foundation

public struct SpeculidApplicationModeParser: SpeculidApplicationModeParserProtocol {
  private func parseInitializeArguments(_ arguments: [String]) -> SpeculidCommandArgumentSet? {
    let urls = arguments.compactMap { filePath -> URL? in
      guard FileManager.default.fileExists(atPath: filePath) || filePath.components(separatedBy: ".").last?.lowercased() == "speculid" else {
        return nil
      }
      return URL(fileURLWithPath: filePath)
    }
    let types = ["json": "asset", "svg": "image", "appiconset": "asset", "imageset": "asset", "png": "image", "speculid": "destination"]
    let urlTypes = urls.compactMap { url -> (String, URL)? in
      guard let type = types[url.pathExtension.lowercased()] else {
        return nil
      }
      return (type, url)
    }
    let dictionary = [String: [(String, URL)]].init(grouping: urlTypes) {
      $0.0
    }.compactMapValues {
      $0.first?.1
    }
    if let asset = dictionary["asset"], let image = dictionary["image"], let destination = dictionary["destination"] {
      return .initialize(asset: asset, image: image, destination: destination)
    } else {
      return nil
    }
  }
  public func parseMode(fromCommandLine commandLine: CommandLineArgumentProviderProtocol) -> SpeculidApplicationMode {
    var indicies = [Int]()
    if commandLine.arguments.first == Bundle.main.executablePath {
      indicies.append(commandLine.arguments.startIndex)
    }
    if let index = commandLine.arguments.firstIndex(of: "-NSDocumentRevisionsDebugMode") {
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
          return .command(.process(URL(fileURLWithPath: filePath), true))
        } else {
          return .command(.unknown(arguments))
        }
      } else if arguments.contains("--debugLocation") {
        return .command(.debugLocation)
      } else if arguments.contains("--install") {
        return .command(.install(.all))
      } else if let index = arguments.firstIndex(of: "--initialize") {
        let commandArgs = parseInitializeArguments([String](arguments[arguments.index(after: index)...]))
        return .command(commandArgs ?? SpeculidCommandArgumentSet.unknown(arguments))
      } else {
        return .command(.unknown(arguments))
      }
    } else if commandLine.environment["sourceApplicationName"] != nil {
      return .command(.help)
    } else {
      return .cocoa
    }
  }
}
//
// @available(swift, obsoleted: 4.2)
// extension Array where Element: Equatable {
//  func firstIndex(of element: Element) -> Index? {
//    return firstIndex(of: element)
//  }
// }
