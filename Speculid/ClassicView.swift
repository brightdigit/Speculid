//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import SpeculidKit
import Combine

protocol LabeledOption : RawRepresentable, Identifiable where RawValue == Int{
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
    
    var cancellables = [AnyCancellable]()
    
    self.$assetDirectoryRelativePath.sink {
      self.document.document.assetDirectoryRelativePath = $0
    }.store(in: &cancellables)
    
    
    self.$sourceImageRelativePath.sink {
      self.document.document.sourceImageRelativePath = $0
    }.store(in: &cancellables)
    
    self.cancellables = cancellables
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
            self.object.document.build(fromURL: url)
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
