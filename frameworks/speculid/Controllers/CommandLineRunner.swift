import Foundation

public struct InvalidDocumentURL: Error {
  public let url: URL
}
extension Operation: CommandLineActivityProtocol {}

public struct UnknownArgumentsError: Error {
  public let arguments: [String]
}
public class CommandLineRunner: CommandLineRunnerProtocol {
  public var errorStream: TextOutputStream
  public var outputStream: TextOutputStream
  private let _versionProvider: VersionProvider?

  public var versionProvider: VersionProvider {
    return _versionProvider ?? Application.current
  }
  public init(outputStream: TextOutputStream, errorStream: TextOutputStream, versionProvider: VersionProvider? = nil) {
    self.outputStream = outputStream
    self.errorStream = errorStream
    _versionProvider = versionProvider
  }

  public func activity(withArguments arguments: SpeculidCommandArgumentSet, _ completed: @escaping (CommandLineActivityProtocol, Error?) -> Void) -> CommandLineActivityProtocol {
    var error: Error?
    let operation = AsyncBlockOperation { completed in
      switch arguments {
      case .help:
        self.outputStream.write(Application.helpText)
        return completed()
      case let .unknown(arguments):
        self.errorStream.write(Application.unknownCommandMessage(fromArguments: arguments))
        self.outputStream.write(Application.helpText)
        error = UnknownArgumentsError(arguments: arguments)
        return completed()
      case .version:
        if let version = self.versionProvider.version {
          self.outputStream.write(version.developmentDescription)
        } else {
          self.outputStream.write("\(Application.bundle.infoDictionary?["CFBundleShortVersionString"]) (\(Application.bundle.infoDictionary?["CFBundleVersion"]))")
        }
        #if DEBUG
          self.outputStream.write(" DEBUG")
        #endif
        return completed()
      case let .process(url, update):
        let tryDocument: SpeculidDocumentProtocol?
        do {
          tryDocument = try Application.current.document(url: url)
        } catch let caughtError {
          error = caughtError
          return completed()
        }
        guard let document = tryDocument else {
          error = InvalidDocumentURL(url: url)
          return completed()
        }
        error = Application.current.builder.build(document: document)
        return completed()
      case .debugLocation:
        self.outputStream.write(Bundle.main.bundleURL.absoluteString)
        return completed()
      case let .install(type):
        if type.contains(.command) {
          error = CommandLineInstaller.startSync()
          return completed()
        } else {
          return completed()
        }
      }
    }
    operation.completionBlock = {
      completed(operation, error)
    }
    return operation
  }
}
