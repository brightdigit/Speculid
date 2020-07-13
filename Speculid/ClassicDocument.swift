//
//  doc_appDocument.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import UniformTypeIdentifiers
import SpeculidKit


extension UTType {
    static var speculidImageDocument: UTType {
        UTType(importedAs: "com.brightdigit.speculid-image-document")
    }
}

struct SpeculidMutableSpecificationsFile : SpeculidSpecificationsFileProtocol {
  var assetDirectoryRelativePath: String
  var sourceImageRelativePath: String
  var geometry: Geometry?
  var backgroundColor: Color
  var removeAlpha: Bool
  
  var background: NSColor? {
    guard backgroundColor != .clear else {
      return nil
    }
    
    return NSColor(self.backgroundColor)
  }
  
  init (source: SpeculidSpecificationsFileProtocol) {
    self.assetDirectoryRelativePath = source.assetDirectoryRelativePath
    self.sourceImageRelativePath = source.sourceImageRelativePath
    self.geometry = source.geometry
    self.backgroundColor = source.background.map( Color.init ) ?? .clear
    self.removeAlpha = source.removeAlpha
  }
}
struct ClassicDocument: FileDocument {
  var document: SpeculidMutableSpecificationsFile

    init(document: SpeculidSpecificationsFile = SpeculidSpecificationsFile()) {
      self.document = SpeculidMutableSpecificationsFile(source: document)
      
    }

    static var readableContentTypes: [UTType] { [.speculidImageDocument] }

    init(fileWrapper: FileWrapper, contentType: UTType) throws {
      
      dump(fileWrapper.fileAttributes)
      dump(fileWrapper.isRegularFile)
      print(FileManager.default.currentDirectoryPath)
      let decoder = JSONDecoder()
        guard let data = fileWrapper.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
      let document = try decoder.decode(SpeculidSpecificationsFile.self, from: data)
      self.document = SpeculidMutableSpecificationsFile(source: document)
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
      let document = SpeculidSpecificationsFile(source: self.document)
      let encoder = JSONEncoder()
      let data = try encoder.encode(document)
        fileWrapper = FileWrapper(regularFileWithContents: data)
    }
  
  func build (fromURL url: URL) {
    
    let management = FileManagement()
    
    
    let urls = ["assetDirectory" : url.deletingLastPathComponent().appendingPathComponent(document.assetDirectoryRelativePath),
                "sourceImage" : url.deletingLastPathComponent().appendingPathComponent(document.sourceImageRelativePath)]
    
    

    
    let imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    
      let imageSpecifications: [ImageSpecification]

//
    let document : SpeculidDocument
    do {
      document = try SpeculidDocument(sandboxedFromFile: self.document, withURL: url,  decoder: JSONDecoder(), withManager: management)
    } catch {
      debugPrint(error)
      return
    }
    let destinationFileNames = document.assetFile.document.images.map {
      asset in
      (asset, document.destinationName(forImage: asset))
    }
    do {
      imageSpecifications = try destinationFileNames.map { (asset, fileName) -> ImageSpecification in
        try imageSpecificationBuilder.imageSpecification(forURL: document.destinationURL(forFileName: fileName), withSpecifications: document.specificationsFile, andAsset: asset)
      }
    } catch {
      debugPrint(error)
      return //callback(error)
    }
    let service = Service()
    let sourceURL : URL
    do {
      sourceURL = try management.bookmarkURL(fromURL: document.sourceImageURL)
    } catch {
      debugPrint(error)
      return
    }
    service.exportImageAtURL(sourceURL, toSpecifications: imageSpecifications) { (error) in
      debugPrint(error)
    }
    
//    builder.build(document: document)
  }
}

struct ClassicDocument_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
