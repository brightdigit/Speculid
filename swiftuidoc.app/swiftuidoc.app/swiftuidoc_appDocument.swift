import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var exampleText: UTType {
    UTType(importedAs: "com.example.plain-text")
  }
}

struct swiftuidoc_appDocument: FileDocument {
  var text: String

  init(text: String = "Hello, world!") {
    self.text = text
  }

  static var readableContentTypes: [UTType] { [.exampleText] }

  init(fileWrapper: FileWrapper, contentType _: UTType) throws {
    guard let data = fileWrapper.regularFileContents,
      let string = String(data: data, encoding: .utf8)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    text = string
  }

  func write(to fileWrapper: inout FileWrapper, contentType _: UTType) throws {
    let data = text.data(using: .utf8)!
    fileWrapper = FileWrapper(regularFileWithContents: data)
  }
}
