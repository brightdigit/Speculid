import AssetLib
import SpeculidKit
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var speculidImageDocument: UTType {
    UTType(importedAs: "com.brightdigit.speculid-image-document")
  }
}

struct ClassicDocument: FileDocument {
  var document: SpeculidMutableSpecificationsFile

  init(document: SpeculidSpecificationsFile = SpeculidSpecificationsFile()) {
    self.document = SpeculidMutableSpecificationsFile(source: document)
  }

  static var readableContentTypes: [UTType] { [.speculidImageDocument] }

  init(fileWrapper: FileWrapper, contentType _: UTType) throws {
    let decoder = JSONDecoder()
    guard let data = fileWrapper.regularFileContents
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    let document = try decoder.decode(SpeculidSpecificationsFile.self, from: data)
    self.document = SpeculidMutableSpecificationsFile(source: document)
  }

  func write(to fileWrapper: inout FileWrapper, contentType _: UTType) throws {
    let document = SpeculidSpecificationsFile(source: self.document)
    let encoder = JSONEncoder()
    let data = try encoder.encode(document)
    fileWrapper = FileWrapper(regularFileWithContents: data)
  }

  func build(fromURL url: URL, inSandbox sandbox: Sandbox) {
    let document: SpeculidDocument
    do {
      document = try SpeculidDocument(sandboxedFromFile: self.document, withURL: url, decoder: JSONDecoder(), withManager: sandbox)
    } catch {
      debugPrint(error)
      debugPrint(error.localizedDescription)
      return
    }

    let destinationFileNames = document.assetFile.document.images.map {
      asset in
      (asset, document.destinationName(forImage: asset))
    }

    let urlMap = destinationFileNames.map { asset, fileName in
      (asset, fileName, document.destinationURL(forFileName: fileName))
    }

    processImages(fromURL: url, management: sandbox, document: document, sandboxMap: urlMap)
  }

  func processImages(fromURL url: URL, management: Sandbox, document: SpeculidDocument, sandboxMap: [(AssetSpecificationProtocol, String, URL)]) {
    let assetDirectoryURL = url.deletingLastPathComponent().appendingPathComponent(self.document.assetDirectoryRelativePath)

    let imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    let imageSpecifications: [ImageSpecification]
    do {
      imageSpecifications = try sandboxMap.map { (asset, _, url) -> ImageSpecification in
        try imageSpecificationBuilder.imageSpecification(forURL: url, withSpecifications: document.specificationsFile, andAsset: asset)
      }
    } catch {
      debugPrint(error)
      return // callback(error)
    }

    let service = Service()
    let sourceURL: URL
    do {
      sourceURL = try management.bookmarkURL(fromURL: document.sourceImageURL)
    } catch {
      debugPrint(error)
      return
    }
    let destinationURL = try? management.bookmarkURL(fromURL: assetDirectoryURL)

    destinationURL?.startAccessingSecurityScopedResource()

    let acessingScoped = sourceURL.startAccessingSecurityScopedResource()
    service.exportImageAtURL(sourceURL, toSpecifications: imageSpecifications) { error in

      if acessingScoped {
        sourceURL.stopAccessingSecurityScopedResource()
      }
      if error != nil {
        return
      }
      NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: assetDirectoryURL.path)
    }
  }
}

struct ClassicDocument_Previews: PreviewProvider {
  static var previews: some View {
    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
  }
}
