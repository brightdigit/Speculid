import Cocoa
import SpeculidKit

struct NoBookmarkAvailableError : Error {
  
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
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
  
  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
    
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
//    let fromURL = (try? bookmarkURL(fromURL: fromPathURL)) ?? fromPathURL
//    let toURL = (try? bookmarkURL(fromURL: toPathURL)) ?? toPathURL
//    do {
//    try FileTesting.copyFile(from: fromURL, to: toURL)
//    } catch let error as NSError {
////      guard error.domain == NSCocoaErrorDomain && (error.code == 513 || error.code == 257) else {
////        throw error
////      }
//      debugPrint(error)
//      let panel : NSSavePanel
//      let openPanel = NSOpenPanel()
//      openPanel.message = "Choose your directory"
//      openPanel.prompt = "Choose"
//      openPanel.allowedFileTypes = ["speculid"]
//      openPanel.allowsOtherFileTypes = false
//      openPanel.canChooseFiles = true
//      openPanel.canChooseDirectories = false
//      panel = openPanel
//      let response = panel.runModal()
//
//      if response == .OK {
//        let bookmarkResults = [URL : Result<Data, Error>].init(uniqueKeysWithValues: openPanel.urls.map { url  in
//          return (url, Result {
//            try url.bookmarkData()
//          })
//        })
//
//        var bookmarkMap = defaults.dictionary(forKey: "bookmarks") as? [String : Data] ?? [String : Data]()
//
//        for (url, result) in bookmarkResults {
//          switch result {
//          case .success(let bookmarkData):
//            bookmarkMap[url.path] = bookmarkData
//          case .failure(let error):
//            debugPrint(error)
//          }
//        }
//        defaults.set(bookmarkMap, forKey: "bookmarks")
//      }
//      //print(openPanel.urls) // this contains the chosen folder
//    }
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
}
