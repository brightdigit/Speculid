import Cocoa
import SpeculidKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   let defaults: UserDefaults! = UserDefaults(suiteName: "MLT7M394S7.group.com.brightdigit.Speculid")
  
  func applicationDidFinishLaunching(_: Notification) {
    // Insert code here to initialize your application
    
    do {
    try FileTesting.copyFile(from: URL(fileURLWithPath: #file), to: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("AppDelegate.copy"))
    } catch {
      debugPrint(error)
      let openPanel = NSOpenPanel()
      openPanel.message = "Choose your directory"
      openPanel.prompt = "Choose"
      openPanel.allowedFileTypes = ["speculid"]
      openPanel.allowsOtherFileTypes = false
      openPanel.canChooseFiles = true
      openPanel.canChooseDirectories = false

      let response = openPanel.runModal()
      
      if response == .OK {
        let bookmarkResults = [URL : Result<Data, Error>].init(uniqueKeysWithValues: openPanel.urls.map { url  in
          return (url, Result {
            try url.bookmarkData()
          })
        })
        
        var bookmarkMap = defaults.dictionary(forKey: "bookmarks") as? [String : Data] ?? [String : Data]()
        
        for (url, result) in bookmarkResults {
          switch result {
          case .success(let bookmarkData):
            bookmarkMap[url.path] = bookmarkData
          case .failure(let error):
            debugPrint(error)
          }
        }
        defaults.set(bookmarkMap, forKey: "bookmarks")
      }
      //print(openPanel.urls) // this contains the chosen folder
    }
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application
  }
}
