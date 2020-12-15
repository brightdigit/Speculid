import SwiftUI

@main
struct SpeculidApp: App {
  @StateObject private var bookmarkCollection = BookmarkURLCollectionObject()
  @State private var isExporting: Bool = false

  @SceneBuilder var body: some Scene {
    DocumentGroup(newDocument: ClassicDocument()) { file in
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
