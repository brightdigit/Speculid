//
//  BookmarkURLCollectionObject.swift
//  Speculid
//
//  Created by Leo Dion on 7/14/20.
//

import Foundation
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
