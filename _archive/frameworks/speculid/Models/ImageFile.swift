import CairoSVG
import Cocoa

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
    aCoder.encode(format.rawValue, forKey: "format")
  }

  public required init?(coder aDecoder: NSCoder) {
    let urlOptional = aDecoder.decodeObject(forKey: "url") as? URL
    let formatRawValueOptional = aDecoder.decodeObject(forKey: "format") as? UInt

    guard let url = urlOptional, let formatRawValue = formatRawValueOptional, let format = ImageFileFormat(rawValue: formatRawValue) else {
      return nil
    }

    self.url = url
    self.format = format
  }
  // swiftlint:enable identifier_name
  public let url: URL
  public let format: ImageFileFormat
  public init(url: URL, format: ImageFileFormat) {
    self.url = url
    self.format = format
    super.init()
  }
}

extension ImageFile {
  public convenience init(url: URL) throws {
    let pathExtension = url.pathExtension
    let format: ImageFileFormat
    if pathExtension.caseInsensitiveCompare("png") == .orderedSame {
      format = .png
    } else if pathExtension.caseInsensitiveCompare("svg") == .orderedSame {
      format = .svg
    } else if pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
      format = .pdf
    } else {
      throw UnknownFileFormatError(forURL: url)
    }
    self.init(url: url, format: format)
  }
}
