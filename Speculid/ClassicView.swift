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
    Form{
      Section(header: Text("Source Graphic")){
        HStack{
          Spacer()
          Text("File Path:").frame(width: 75, alignment: .trailing)
          TextField("SVG of PNG File", text: self.$object.sourceImageRelativePath)
            .overlay(Image(systemName: "folder.fill").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 250).onTapGesture {
              self.importFiles(singleOfType: [.svg, .png]) { (result) in
                guard case let .success(url) = result else {
                  return
                }
                bookmarkCollection.saveBookmark(url)
              }
            }
          Image(systemName: "lock.fill").foregroundColor(.yellow).opacity(self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.sourceImageRelativePath) ? 0.0 : 1.0)
          Spacer()
        }
      }
      Divider()
      Section(header: Text("Asset Catalog")){
        HStack{
          Spacer()
          Text("Folder:").frame(width: 75, alignment: .trailing)
          TextField(".appiconset or .imageset", text: self.$object.assetDirectoryRelativePath)
            .overlay(Image(systemName: "folder.fill").foregroundColor(.primary).padding(.trailing, 4.0), alignment: .trailing)
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).frame(width: 250).onTapGesture {
              self.importFiles(singleOfType: [.directory]) { (result) in
                guard case let .success(url) = result else {
                  return
                }
                bookmarkCollection.saveBookmark(url)
              }
            }
          Image(systemName: "lock.fill").foregroundColor(.yellow).opacity(self.bookmarkCollection.isAvailable(basedOn: self.object.url, relativePath: self.object.assetDirectoryRelativePath) ? 0.0 : 1.0)
          Spacer()
        }
      }
      Divider()
      Section(header: Text("App Icon Modifications")) {
        HStack{
          VStack(alignment: .leading){
            Toggle("Remove Alpha Channel", isOn: self.$object.removeAlpha)
            Text("If this is intended for an iOS, watchOS, or tvOS App, then you should remove the alpha channel from the source graphic.").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
          }
          Spacer()
        }
        VStack(alignment: .leading){
          HStack{
            Toggle("Add a Background Color", isOn: self.$object.addBackground)
            ColorPicker("", selection: self.$object.backgroundColor, supportsOpacity: false).labelsHidden().frame(width: 40, height: 25, alignment: .trailing).disabled(!self.object.addBackground).opacity(self.object.addBackground ? 1.0 : 0.5)
          }
          Text("If this is intended for an iOS, watchOS, or tvOS App, then you should set a background color.").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
        }
      }.disabled(!self.object.isAppIcon).opacity(self.object.isAppIcon ? 1.0 : 0.5)
      Divider()
      Section(header: Text("Resizing Geometry")) {
        HStack{
          Picker("Resize", selection: self.$object.resizeOption) {
            ForEach(ResizeOption.all) {
              Text($0.label).tag($0.rawValue)
            }
          }.pickerStyle(SegmentedPickerStyle())
          .frame(width: 150, alignment: .leading).labelsHidden()
          TextField("Value", value: self.$object.geometryValue, formatter: NumberFormatter()).frame(width: 50, alignment: .leading).disabled(self.object.resizeOption == 0).opacity(self.object.resizeOption == 0 ? 0.5 : 1.0)
          Text("px").opacity(self.object.resizeOption == 0 ? 0.5 : 1.0)
        }
        Text("If you wish to render scaled PNG files for an image set, then specify either width or height and the image will be resized to that dimention while retaining its aspect ratio.\nOtherwise if you select \"None\", then only a PDF will be rendered.   ").multilineTextAlignment(.leading).font(.subheadline).lineLimit(nil)
      }.disabled(!self.object.isImageSet).opacity(self.object.isImageSet ? 1.0 : 0.5)
      Divider()
      Section{
        HStack{
          Button {
            if let url = self.object.url {
              self.object.document.build(fromURL: url, inSandbox: self.bookmarkCollection)
            }
          } label: {
            HStack{
              Image(systemName: "play.fill")
              Text("Build")
            }
          }

        }
      }
    }.padding(.all, 40.0).frame(minWidth: 500, idealWidth: 500, maxWidth: 600, minHeight: 500, idealHeight: 500, maxHeight: .infinity, alignment: .center)
  }
}

struct ClassicView_Previews: PreviewProvider {
  static var previews: some View {
    ClassicView(url: nil, document: ClassicDocument(), documentBinding: .constant(ClassicDocument())).environmentObject(BookmarkURLCollectionObject())
  }
}
