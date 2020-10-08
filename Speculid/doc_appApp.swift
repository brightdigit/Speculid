import SwiftUI

@main
struct doc_appApp: App {
  @StateObject private var bookmarkCollection = BookmarkURLCollectionObject()
  @State private var isExporting : Bool = false

  @SceneBuilder var body: some Scene {
//    DocumentGroup(newDocument: ClassicDocument()) { (file) in
//      return EmptyView().fileExporter(isPresented: $isExporting, document: file.document, contentType: .speculidImageDocument, defaultFilename: "AppIcon.speculid") { (result) in
//        print(result)
//      }.onAppear{
//        self.isExporting = true
//      }
//    }
   
    DocumentGroup(newDocument: ClassicDocument()) { (file) in
      ClassicView(url: file.fileURL, document: file.document, documentBinding: file.$document).environmentObject(bookmarkCollection)
    }
    
//    DocumentGroup(viewing: ClassicDocument.self) { file in
//
//      ClassicView(url: file.fileURL, document: file.document, documentBinding: file.$document).environmentObject(bookmarkCollection)
//    }
    .commands {
      CommandMenu("Developer Tools") {
        Button("Reset Bookmarks") {
          self.bookmarkCollection.reset()
        }
      }
    }
  }
}
