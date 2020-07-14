//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import SpeculidKit

@propertyWrapper struct UserDefaultsBacked<Value> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard

  var wrappedValue: Value {
      get { UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue }
      nonmutating set { UserDefaults.standard.set(newValue, forKey: key) }
  }
  var projectedValue: Binding<Value> {
      Binding<Value>( get: { self.wrappedValue }, set: { newValue in self.wrappedValue = newValue } )
  }
}

extension UserDefaults {
  
  @objc
  var bookmarks : [String : Data]? {
    get {
      self.dictionary(forKey: "bookmarks") as? [String : Data]
    }
    set {
      self.set(newValue, forKey: "bookmarks")
    }
  }
}

public class BookmarkURLCollectionObject : ObservableObject {

  //@AppStorage("bookmarks", store: UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid"))
//  @UserDefaultsBacked(key: "bookmarks", defaultValue: [String : Data](), storage: UserDefaults.shared)
  
  static let shared: UserDefaults  = {
      let combined = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")!
      combined.register(defaults: ["bookmarks" : [String : Data]()])
      return combined
  }()
  
  @Published var bookmarks  = [URL : URL]()
  
  static func saveBookmark(_ url: URL)  {
    debugPrint("saving bookmark for \(url)")
    guard let newData =  try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) else {
      return
    }
    var bookmarkMap = Self.shared.bookmarks ?? [String : Data]()
    bookmarkMap[url.path] = newData
    Self.shared.bookmarks = bookmarkMap
    
  }
  
  func reset () {
    Self.shared.bookmarks = [String : Data]()
  }
  
  func isAvailable(basedOn baseURL: URL?, relativePath: String ...) -> Bool {
    guard let baseURL = baseURL else {
      return false
    }
    
    var url = baseURL.deletingLastPathComponent()
    for path in relativePath {
      url.appendPathComponent(path)
    }
    
    return self.bookmarks[url] != nil
  }
  
  static func transformPath(_ path: String, withBookmarkData bookmarkData: Data) -> (URL, URL)? {
    
    var isStale : Bool = false
    
     
    guard let url = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale) else {
      return nil
    }
    

//    if isStale {
//      DispatchQueue.global().async {
//        saveBookmark(url)
//      }
//
//    }
    debugPrint("Adding \(isStale ? "stale" : "fresh") bookmark of \(path) for \(url)")
    return (URL(fileURLWithPath: path), url)
  }
  
  init () {
    let bookmarkPublisher = Self.shared.publisher(for: \.bookmarks).compactMap{$0}
    bookmarkPublisher.map{
      Dictionary(uniqueKeysWithValues:
      $0.compactMap(Self.transformPath))
    }.receive(on: DispatchQueue.main).assign(to: self.$bookmarks)
  
    
  }
}


struct ClassicView: View {
  let fileManagement = FileManagement()
  let url : URL?
    @Binding var document: ClassicDocument
  @EnvironmentObject var bookmarkCollection : BookmarkURLCollectionObject
  @Environment(\.importFiles) var importFiles
  @Environment(\.exportFiles) var exportFiles
  
  var canBuild : Bool {
    return url != nil &&
      self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath, "Contents.json") &&
      self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.sourceImageRelativePath)
  }
    var body: some View {
      VStack{
        Text(url?.absoluteString ?? "")
        Button(action: {
          self.importFiles(singleOfType: [.svg, .png]) { (result) in
            guard case let .success(url) = result else {
              return
            }
            let saveResult = Result{ try fileManagement.saveBookmark(url) }
            guard case .success = saveResult else {
              return
            }
            let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
          }
        }, label: {
          HStack{
            Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.sourceImageRelativePath) ? "lock.open.fill" : "lock.fill")
            Image(systemName: "photo.fill")
            Text(self.document.document.sourceImageRelativePath)
          }
        })
        
          Button(action: {
            
            self.importFiles(singleOfType: [.directory]) { (result) in
              guard case let .success(url) = result else {
                return
              }
              //let url = jsonURL.deletingLastPathComponent()
              
              debugPrint(url.path)
              debugPrint(self.url?.deletingLastPathComponent().appendingPathComponent(self.document.document.assetDirectoryRelativePath).path)
              guard url.path == self.url?.deletingLastPathComponent().appendingPathComponent(self.document.document.assetDirectoryRelativePath).path else {
                return
              }
              let saveResult = Result{ try fileManagement.saveBookmark(url) }
                /*.flatMap{
                Result{ try fileManagement.saveBookmark(jsonURL)}
              }*/
              guard case .success = saveResult else {
                debugPrint(saveResult)
                return
              }
              let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
//              let jsonURLResult = Result{ try fileManagement.bookmarkURL(fromURL: jsonURL) }
//              debugPrint(jsonURLResult)
            }
          }, label: {
            HStack{
              Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath, "Contents.json") ? "lock.open.fill" : "lock.fill")
              Image(systemName: "photo.fill")
              Text(self.document.document.assetDirectoryRelativePath)
            }
          })
        
          Button(action: {
            self.importFiles(singleOfType: [.json]) { (result) in
              guard case let .success(url) = result else {
                return
              }
              //let url = jsonURL.deletingLastPathComponent()
              
              let saveResult = Result{ try fileManagement.saveBookmark(url) }
                /*.flatMap{
                Result{ try fileManagement.saveBookmark(jsonURL)}
              }*/
              guard case .success = saveResult else {
                debugPrint(saveResult)
                return
              }
              let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
//              let jsonURLResult = Result{ try fileManagement.bookmarkURL(fromURL: jsonURL) }
//              debugPrint(jsonURLResult)
            }
          }, label: {
            HStack{
              Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath, "Contents.json") ? "lock.open.fill" : "lock.fill")
              Image(systemName: "photo.fill")
              Text(self.document.document.assetDirectoryRelativePath)
            }
          })
        Toggle("Remove Alpha", isOn: self.$document.document.removeAlpha)
        ColorPicker("Background Color", selection: self.$document.document.backgroundColor)
       
        Button("Build") {
          if let url = self.url {
            
            self.document.build(fromURL: url, onExport: {
              urls, callback in
              exportFiles(moving: urls) { (result) in
                guard let result = result else {
                  callback(.failure(NSError()))
                  return
                }
                let flatResult = result.flatMap { (sourceUrls)  in
                  Result{
                  try sourceUrls.map{
                    url throws -> (URL,URL)  in
                    try fileManagement.saveBookmark(url)
                    let resultURL = try fileManagement.bookmarkURL(fromURL: url)
                    return (url, resultURL)
                  }
                  }
                }
                let dictionaryResult = flatResult.map(Dictionary.init(uniqueKeysWithValues:))
                callback(dictionaryResult)
              }
            })
          }
        }.disabled(!self.canBuild)
        
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(url: nil, document: .constant(ClassicDocument()))
    }
}
