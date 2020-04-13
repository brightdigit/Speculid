import Foundation

protocol SpeculidDocumentErrorDetail {
  init?(_ error: Error)
  var innerError: Error? { get }
  var message: String { get }
}

struct InvalidSetUrlDetail: SpeculidDocumentErrorDetail {
  public let filePath: String

  var message: String {
    let filePathURL = URL(fileURLWithPath: filePath)
    let filePathDirURL = filePathURL.deletingLastPathComponent()
    let contentsName = filePathURL.lastPathComponent
    return "There is no file \"\(contentsName)\" located at the set: \"\(filePathDirURL.path)\"."
  }

  init?(_ error: Error) {
    let nsError = error as NSError

    guard nsError.domain == NSCocoaErrorDomain, nsError.code == 260 else {
      return nil
    }

    guard let filePath = nsError.userInfo[NSFilePathErrorKey] as? String else {
      return nil
    }

    self.filePath = filePath
    innerError = error
  }

  public let innerError: Error?
}

struct AnotherDetail: SpeculidDocumentErrorDetail {
  var message: String {
    ""
  }

  init?(_: Error) {
    nil
  }

  var innerError: Error? {
    nil
  }
}

struct SpeculidDocumentError: Error, LocalizedError {
  let detail: SpeculidDocumentErrorDetail
  static let factories: [(Error) -> SpeculidDocumentErrorDetail?] = [InvalidSetUrlDetail.init, AnotherDetail.init]
  init?(_ error: Error) {
    for factory in Self.factories {
      if let detail = factory(error) {
        self.detail = detail
        return
      }
    }
    return nil
  }

  var localizedDescription: String {
    detail.message
  }

  var errorDescription: String? {
    detail.message
  }
}

public struct SpeculidDocument: SpeculidDocumentProtocol {
  public let url: URL
  public let specificationsFile: SpeculidSpecificationsFileProtocol
  public let assetFile: AssetSpecificationFileProtocol

  public init(url: URL, decoder: JSONDecoder, configuration _: SpeculidConfigurationProtocol? = nil) throws {
    let specificationsFileData = try Data(contentsOf: url)
    let specificationsFile = try decoder.decode(SpeculidSpecificationsFile.self, from: specificationsFileData)

    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(specificationsFile.assetDirectoryRelativePath, isDirectory: true).appendingPathComponent("Contents.json")

    let assetData: Data
    do {
      assetData = try Data(contentsOf: contentsJSONURL)
    } catch let caughtError {
      if let error = SpeculidDocumentError(caughtError) {
        throw error
      }
      #if DEBUG
        dump(caughtError)
      #endif
      throw caughtError
    }
    let asset = try decoder.decode(AssetSpecificationDocument.self, from: assetData)

    self.specificationsFile = specificationsFile
    assetFile = AssetSpecificationFile(url: contentsJSONURL, document: asset)
    self.url = url
  }
}
