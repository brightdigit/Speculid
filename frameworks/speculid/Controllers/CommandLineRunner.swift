import Foundation

public struct InvalidDocumentURL: Error {
  public let url: URL
}
extension Operation: CommandLineActivityProtocol {
}

public struct UnknownArgumentsError: Error {
  public let arguments: [String]
}
public class CommandLineRunner: CommandLineRunnerProtocol {
  public var errorStream: TextOutputStream
  public var outputStream: TextOutputStream

  public init(outputStream: TextOutputStream, errorStream: TextOutputStream) {
    self.outputStream = outputStream
    self.errorStream = errorStream
  }

  public func activity(withArguments arguments: SpeculidCommandArgumentSet, _ completed: @escaping (CommandLineActivityProtocol, Error?) -> Void) -> CommandLineActivityProtocol {
    var error: Error?
    let operation = AsyncBlockOperation { completed in
      switch arguments {
      case .help:
        self.outputStream.write(Application.helpText)
        return completed()
      case let .unknown(arguments):
        self.errorStream.write(Application.errorText)
        self.outputStream.write(Application.helpText)
        error = UnknownArgumentsError(arguments: arguments)
        return completed()
      case .version:
        if let version = Application.current.version {
          self.outputStream.write(version.developmentDescription)
        } else {
          self.outputStream.write("\(Application.bundle.infoDictionary?["CFBundleShortVersionString"]) (\(Application.bundle.infoDictionary?["CFBundleVersion"]))")
        }
        return completed()
      case let .file(url):
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
      }
    }
    operation.completionBlock = {
      completed(operation, error)
    }
    return operation
  }
}
