import AssetLib
import SpeculidKit
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var speculidImageDocument: UTType {
    UTType(importedAs: "com.brightdigit.speculid-image-document")
  }
}

class ClassicDocument: FileDocument, SpeculidSpecificationsFileProtocol, ObservableObject {
  @Published public var assetDirectoryRelativePath: String
  @Published public var sourceImageRelativePath: String
  @Published public var geometry: Geometry?
  @Published public var background: NSColor?
  @Published public var removeAlpha: Bool
  
  //var document: SpeculidMutableSpecificationsFile

  init(source: SpeculidSpecificationsFile = SpeculidSpecificationsFile()) {
    
      assetDirectoryRelativePath = source.assetDirectoryRelativePath
      sourceImageRelativePath = source.sourceImageRelativePath
      geometry = source.geometry
      background = source.background
      removeAlpha = source.removeAlpha
  }

  static var readableContentTypes: [UTType] { [.speculidImageDocument] }
  static var writableContentTypes: [UTType]  { [.speculidImageDocument] }
  
  required init(configuration: ReadConfiguration) throws {
    
      let decoder = JSONDecoder()
    guard let data = configuration.file.regularFileContents
      else {
        throw CocoaError(.fileReadCorruptFile)
      }
      let source = try decoder.decode(SpeculidSpecificationsFile.self, from: data)
      
    
      assetDirectoryRelativePath = source.assetDirectoryRelativePath
      sourceImageRelativePath = source.sourceImageRelativePath
      geometry = source.geometry
      background = source.background
      removeAlpha = source.removeAlpha
  }

//  func write(to fileWrapper: inout FileWrapper, contentType _: UTType) throws {
//    let document = SpeculidSpecificationsFile(source: self.document)
//    let encoder = JSONEncoder()
//    let data = try encoder.encode(document)
//    fileWrapper = FileWrapper(regularFileWithContents: data)
//  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    debugPrint(self.assetDirectoryRelativePath)
    let document = SpeculidSpecificationsFile(source: self)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [ .prettyPrinted, .withoutEscapingSlashes ]
    
    let data = try encoder.encode(document)
    return FileWrapper(regularFileWithContents: data)
  }

  func build(fromURL url: URL, inSandbox sandbox: Sandbox) {
    let document: SpeculidDocument
    do {
      document = try SpeculidDocument(sandboxedFromFile: self, withURL: url, decoder: JSONDecoder(), withManager: sandbox)
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
    let assetDirectoryURL = url.deletingLastPathComponent().appendingPathComponent(self.assetDirectoryRelativePath)

    let imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    let imageSpecifications: [ImageSpecificationObject]
    do {
      imageSpecifications = try sandboxMap.map { (asset, _, url) -> ImageSpecificationObject in
        try imageSpecificationBuilder.imageSpecification(forURL: url, withSpecifications: document.specificationsFile, andAsset: asset)
      }
    } catch {
      debugPrint(error)
      return // callback(error)
    }

    let service = ServiceObject()
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
