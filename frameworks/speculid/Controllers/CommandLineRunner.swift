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
    _versionProvider ?? Application.current
  }

  public init(outputStream: TextOutputStream, errorStream: TextOutputStream, versionProvider: VersionProvider? = nil) {
    self.outputStream = outputStream
    self.errorStream = errorStream
    _versionProvider = versionProvider
  }

  fileprivate func saveSpeculidFileURL(_ destination: URL, usingImageURL image: URL, forAssetURL asset: URL) throws {
    let file = SpeculidSpecificationsFile(assetURL: asset, sourceImageURL: image, destinationURL: destination)
    let jsonEncoder = JSONEncoder()
    if #available(OSX 10.15, *) {
      jsonEncoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
    } else {
      jsonEncoder.outputFormatting = [.prettyPrinted]
    }

    let data = try jsonEncoder.encode(file)
    try data.write(to: destination, options: .atomic)
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
        let documents: [SpeculidDocumentProtocol]
        do {
          documents = try Application.current.documents(url: url)
        } catch let caughtError {
          error = caughtError
          return completed()
        }
        error = Application.current.builder.build(documents: documents)
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
      case let .initialize(asset: asset, image: image, destination: destination):
        do {
          try self.saveSpeculidFileURL(destination, usingImageURL: image, forAssetURL: asset)
        } catch let caughtError {
          error = caughtError
        }

        return completed()
      }
    }
    operation.completionBlock = {
      completed(operation, error)
    }
    return operation
  }
}
