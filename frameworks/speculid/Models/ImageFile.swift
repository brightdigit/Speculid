import Cocoa
import CairoSVG

public struct UnknownFileFormatError: Error {
  public let url: URL

  public init(forURL url: URL) {
    self.url = url
  }
}

public class ImageFile: NSObject, ImageFileProtocol, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(url, forKey: "url")
    aCoder.encode(fileFormat.imageFileFormat.rawValue, forKey: "fileFormatValue")
  }

  public required init?(coder aDecoder: NSCoder) {
    let _url = aDecoder.decodeObject(forKey: "url") as? URL
    let _fileFormatValue = aDecoder.decodeObject(forKey: "fileFormatValue") as? UInt

    guard let url = _url, let fileFormatValue = _fileFormatValue, let fileFormat = FileFormat(rawValue: fileFormatValue) else {
      return nil
    }

    self.url = url
    self.fileFormat = fileFormat
  }

  public let url: URL
  public let fileFormat: FileFormat
  public init(url: URL, fileFormat: FileFormat) {
    self.url = url
    self.fileFormat = fileFormat
    super.init()
  }

  public var format: ImageFileFormat {
    return fileFormat.imageFileFormat
  }
}

extension ImageFile {
  public convenience init(url: URL) throws {
    let pathExtension = url.pathExtension
    let fileFormat: FileFormat
    if pathExtension.caseInsensitiveCompare("png") == .orderedSame {
      fileFormat = .png
    } else if pathExtension.caseInsensitiveCompare("svg") == .orderedSame {
      fileFormat = .svg
    } else if pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
      fileFormat = .pdf
    } else {
      throw UnknownFileFormatError(forURL: url)
    }
    self.init(url: url, fileFormat: fileFormat)
  }
}
