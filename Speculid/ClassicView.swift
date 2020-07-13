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
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        combined.addSuite(named: "MLT7M394S7.group.com.brightdigit.Speculid")
        return combined
    }
  
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
  @Published var bookmarks  = [URL : URL]()
  
  static func saveBookmark(_ url: URL)  {
    guard let newData =  try? url.bookmarkData() else {
      return
    }
    var bookmarkMap = UserDefaults.shared.bookmarks ?? [String : Data]()
    bookmarkMap[url.path] = newData
    UserDefaults.shared.bookmarks = bookmarkMap
    
  }
  
  func isAvailable(basedOn baseURL: URL?, relativePath: String) -> Bool {
    guard let baseURL = baseURL else {
      return false
    }
    
    let url = baseURL.deletingLastPathComponent().appendingPathComponent(relativePath)
    
    return self.bookmarks[url] != nil
  }
  
  static func transformPath(_ path: String, withBookmarkData bookmarkData: Data) -> (URL, URL)? {
    
    var isStale : Bool = false
    guard let url = try? URL.init(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale) else {
      return nil
    }

    if isStale {
      saveBookmark(url)
    }
    return (URL(fileURLWithPath: path), url)
  }
  
  init () {
    let bookmarkPublisher = UserDefaults.shared.publisher(for: \.bookmarks).compactMap{$0}
    bookmarkPublisher.map{
      Dictionary(uniqueKeysWithValues:
      $0.compactMap(Self.transformPath))
    }.assign(to: self.$bookmarks)
  
    
  }
}


struct ClassicView: View {
  let fileManagement = FileManagement()
  let url : URL?
    @Binding var document: ClassicDocument
  @EnvironmentObject var bookmarkCollection : BookmarkURLCollectionObject
  @Environment(\.importFiles) var importFiles
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
            debugPrint(urlResult)
          }
        }, label: {
          HStack{
            Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.sourceImageRelativePath) ? "lock.open.fill" : "lock.fill")
            Image(systemName: "photo.fill")
            Text(self.document.document.sourceImageRelativePath)
          }
        })
        
          Button(action: {
            self.importFiles(singleOfType: [.json]) { (result) in
              guard case let .success(jsonURL) = result else {
                return
              }
              let url = jsonURL.deletingLastPathComponent()
              let saveResult = Result{ try fileManagement.saveBookmark(url) }
              guard case .success = saveResult else {
                return
              }
              let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
              debugPrint(urlResult)
            }
          }, label: {
            HStack{
              Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath) ? "lock.open.fill" : "lock.fill")
              Image(systemName: "photo.fill")
              Text(self.document.document.assetDirectoryRelativePath)
            }
          })
        
        Toggle("Remove Alpha", isOn: self.$document.document.removeAlpha)
        ColorPicker("Background Color", selection: self.$document.document.backgroundColor)
       
        
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(url: nil, document: .constant(ClassicDocument()))
    }
}
