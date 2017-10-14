import Cocoa
import CairoSVG

public enum FileFormat: UInt {
  case png
  case svg
  case pdf
}

extension FileFormat {
  var imageFileFormat: ImageFileFormat {
    switch self {
    case .pdf: return ImageFileFormat.pdf
    case .png: return ImageFileFormat.png
    case .svg: return ImageFileFormat.svg
    }
  }
}
