//
//  FileManagement.swift
//  Speculid
//
//  Created by Leo Dion on 4/4/20.
//

import Foundation
import AppKit
import SpeculidKit

struct NoBookmarkAvailableError : Error {
  
}


struct FileManagement {
  let defaults: UserDefaults! = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")
   
   func resultFrom<Input, Output> (_ closure: @escaping (Input) throws -> Output) -> (Input) -> Result<Output, Error> {
     return {
       input in
       Result{ try closure(input)}
     }
   }
   
   func saveBookmark(_ url: URL) throws {
     
     let newData =  try url.bookmarkData()
     var bookmarkMap = defaults.dictionary(forKey: "bookmarks") as? [String : Data] ?? [String : Data]()
     bookmarkMap[url.path] = newData
     defaults.set(bookmarkMap, forKey: "bookmarks")
   }
   
   func bookmarkURL(fromURL url: URL) throws -> URL {
     let bookmarks = defaults.dictionary(forKey: "bookmarks") as? [String : Data]
     var isStale : Bool = false
     let fromURLResult : Result<URL, Error>
     let fromURLCurrentResult = bookmarks?[url.path].map{
       data in
       Result{
         try URL.init(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale)
       }
     }
     if isStale {
       try saveBookmark(url)
     }
     fromURLResult = fromURLCurrentResult ?? .failure(NoBookmarkAvailableError())
     return try fromURLResult.get()
   }
   
   func withinSandbox(urls: [String : URL], _ fileoperation: ([String: URL]) throws -> Void, otherwise : (Any) -> NSSavePanel?) throws {
     let map = resultFrom(bookmarkURL(fromURL:))
     let bookmarkedUrls = urls.mapValues(map)
     var successfulUrls = [String : URL]()
     var failedUrls = [String : Error]()
     for (key, result) in bookmarkedUrls {
       switch result {
       case .success(let url):
         successfulUrls[key] = url
       case .failure(let error):
         failedUrls[key] = error
       }
     }
     guard failedUrls.count == 0 else {
       guard let panel = otherwise(failedUrls) else {
         return
       }
       let response = panel.runModal()
         
         if response == .OK {
           if let url = panel.url {
             try saveBookmark(url)
           }
           try withinSandbox(urls: urls, fileoperation, otherwise: otherwise)
         }
       return
       }
     
     
     do {
       try fileoperation(successfulUrls)
     } catch let error as NSError {
       guard let panel = otherwise(error) else {
         return
       }
       let response = panel.runModal()
         
         if response == .OK {
           if let url = panel.url {
             try saveBookmark(url)
           }
           try withinSandbox(urls: urls, fileoperation, otherwise: otherwise)
         }
       }
     }
  
  func run () {
    let fromPathURL = URL(fileURLWithPath: "/Users/leo/Documents/Projects/heartwitchapplewatch/AppIcon.speculid")
    let toPathURL = URL(fileURLWithPath: "/Users/leo/Documents/Projects/heartwitchapplewatch")
    try! withinSandbox(urls: ["from" : fromPathURL, "to": toPathURL], {
      urls in
      
      try FileTesting.copyFile(from: urls["from"]!, to: urls["to"]!.appendingPathComponent("AppIcon.speculid").deletingPathExtension().appendingPathExtension("copy.speculid"))
    }, otherwise: {errors in
      
      if let failedUrls = errors as? [String : Error] {
        if failedUrls["to"] != nil {
          let openPanel = NSOpenPanel()
          openPanel.message = "Choose your directory"
          openPanel.prompt = "Choose"
          openPanel.directoryURL = toPathURL.deletingLastPathComponent()
          openPanel.canChooseFiles = false
          openPanel.canChooseDirectories = true
          return openPanel
        }
      }
      let openPanel = NSOpenPanel()
      openPanel.message = "Choose your directory"
      openPanel.prompt = "Choose"
      openPanel.allowedFileTypes = ["speculid"]
      openPanel.allowsOtherFileTypes = false
      openPanel.canChooseFiles = true
      openPanel.canChooseDirectories = false
      return openPanel
    })
  }
}
