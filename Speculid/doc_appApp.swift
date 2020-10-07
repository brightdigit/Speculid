import SwiftUI

@main
struct doc_appApp: App {
  @StateObject private var bookmarkCollection = BookmarkURLCollectionObject()

  @SceneBuilder var body: some Scene {
//    DocumentGroup(newDocument: ClassicDocument()) { (file) in
//      ClassicView(url: file.fileURL, document: file.document, documentBinding: file.$document).environmentObject(bookmarkCollection)
//    }
    DocumentGroup(viewing: ClassicDocument.self) { file in

      ClassicView(url: file.fileURL, document: file.document, documentBinding: file.$document).environmentObject(bookmarkCollection)
    }
    .commands {
      CommandMenu("Developer Tools") {
        Button("Reset Bookmarks") {
          self.bookmarkCollection.reset()
        }
      }
    }
  }
}
