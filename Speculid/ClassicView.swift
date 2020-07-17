//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import SpeculidKit
import Combine

protocol LabeledOption : RawRepresentable, Equatable, Identifiable where RawValue == Int{
  static var mappedValues : [String] { get }
  var label: String { get }
  init (rawValue: RawValue, label : String)
}

extension LabeledOption {
  var id: Int {
    return self.rawValue
  }
  
  static func allValues () -> [Self] {
    self.mappedValues.enumerated().compactMap {
      Self.init(rawValue: $0.offset, label: $0.element)
    }
  }
  
  init?(rawValue: RawValue) {
    self.init(rawValue: rawValue, label: Self.mappedValues[rawValue])
  }
}

struct ResizeOption : LabeledOption {
  static let all = Self.allValues()
  
  let rawValue: Int
  
  static let mappedValues: [ String] =
    [ "None", "Width", "Height"]
  
  let label: String
  
  static let none = all[0]
  static let width = all[1]
  static let height = all[2]
}

extension ResizeOption {
  init(geometryType: GeometryType?) {
    switch (geometryType){
    case .some(.width):
      self = .width
    case .some(.height):
      self = .height
    default:
      self = .none
    }
  }
}

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

struct ClassicView: View {
  @StateObject var object: ClassicObject
  @EnvironmentObject var bookmarkCollection : BookmarkURLCollectionObject
  @Environment(\.importFiles) var importFiles
  
  init (url: URL?, document: ClassicDocument, documentBinding: Binding<ClassicDocument>) {
    self._object = StateObject(wrappedValue: ClassicObject(url: url, document: document))
  }
  
  var canBuild : Bool {
    return self.object.url != nil &&
      
      self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.document.document.assetDirectoryRelativePath)  &&
      
      self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.document.document.sourceImageRelativePath)
  }
  var body: some View {
    VStack{
      Button(action: {
        self.importFiles(singleOfType: [.svg, .png]) { (result) in
          guard case let .success(url) = result else {
            return
          }
          bookmarkCollection.saveBookmark(url)
        }
      }, label: {
        HStack{
          Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.document.document.sourceImageRelativePath) ? "lock.open.fill" : "lock.fill")
          Image(systemName: "photo.fill")
          Text(self.object.sourceImageRelativePath)
        }
      })
      
      Button(action: {
        
        self.importFiles(singleOfType: [.directory]) { (result) in
          guard case let .success(url) = result else {
            return
          }
          bookmarkCollection.saveBookmark(url)
        }
      }, label: {
        HStack{
          Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.document.document.assetDirectoryRelativePath) ? "lock.open.fill" : "lock.fill")
          Image(systemName: "photo.fill")
          Text(self.object.assetDirectoryRelativePath)
        }
      })
      
      
      Toggle("Remove Alpha", isOn: self.$object.removeAlpha)
      ColorPicker("Background Color", selection: self.$object.backgroundColor)
      
      Button("Build") {
        if let url = self.object.url {
          self.object.document.build(fromURL: url, inSandbox: self.bookmarkCollection)
        }
      }.disabled(!self.canBuild)
      
    }
  }
}

struct ClassicView_Previews: PreviewProvider {
  static var previews: some View {
    ClassicView(url: nil, document: ClassicDocument(), documentBinding: .constant(ClassicDocument())).environmentObject(BookmarkURLCollectionObject())
  }
}
