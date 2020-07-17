//
//  ClassicObject.swift
//  Speculid
//
//  Created by Leo Dion on 7/17/20.
//

import Foundation
import SwiftUI
import Combine
import SpeculidKit

class ClassicObject : ObservableObject {
  let url : URL?
  @Published var geometryValue : Float = 0.0
  @Published var assetDirectoryRelativePath: String = ""
  @Published var sourceImageRelativePath: String = ""
  @Published var removeAlpha : Bool = false
  @Published var backgroundColor: Color = .white
  @Published var resizeOption = ResizeOption.none.rawValue
  @Published var addBackground: Bool = false
  
  var document: ClassicDocument
  
  var cancellables = [AnyCancellable]()
  var assetDirectoryURL : URL? {
    self.url?.appendingPathComponent(self.assetDirectoryRelativePath)
  }
  
  var sourceImageURL : URL? {
    self.url?.appendingPathComponent(self.sourceImageRelativePath)
  }
  
  var isAppIcon : Bool {
    self.assetDirectoryRelativePath.lowercased().hasSuffix(".appiconset")
  }
  
  var isImageSet : Bool {
    self.assetDirectoryRelativePath.lowercased().hasSuffix(".imageset")
  }
  
  init (url: URL?, document: ClassicDocument) {
    self.url = url
    self.document = document
    
    self.assetDirectoryRelativePath = self.document.document.assetDirectoryRelativePath
    self.sourceImageRelativePath = self.document.document.sourceImageRelativePath
    self.addBackground = self.document.document.background != nil
    self.backgroundColor = self.document.document.background.map(Color.init) ?? .clear
    self.geometryValue = self.document.document.geometry?.value ?? 0.0
    self.resizeOption = ResizeOption(geometryType: self.document.document.geometry?.dimension).rawValue
    self.removeAlpha = self.document.document.removeAlpha
    
    let nscolorPub = self.$addBackground.combineLatest(self.$backgroundColor) {
      $0 ? NSColor($1) : nil
    }
    
    
    let geoPub = self.$resizeOption.map(ResizeOption.init(rawValue:)).combineLatest(self.$geometryValue) { (option, value) -> Geometry? in
      switch (option) {
      case .some(.width):
        return Geometry(value: value, dimension: .width)
      case .some(.height):
        return Geometry(value: value, dimension: .height)
      default:
        return nil
      }
    }
    
    self.assign($assetDirectoryRelativePath, documentProperty: \.assetDirectoryRelativePath)
    self.assign($sourceImageRelativePath, documentProperty: \.sourceImageRelativePath)
    self.assign($removeAlpha, documentProperty: \.removeAlpha)
    self.assign(nscolorPub, documentProperty: \.background)
    self.assign(geoPub, documentProperty: \.geometry)
  }
  
  func assign<PublisherType : Publisher, ValueType>(_ publisher: PublisherType, documentProperty: WritableKeyPath<SpeculidMutableSpecificationsFile, ValueType>) where PublisherType.Output == ValueType, PublisherType.Failure == Never {
    publisher.sink { (value) in
      self.document.document[keyPath: documentProperty] = value
    }.store(in: &self.cancellables)
  }
}
