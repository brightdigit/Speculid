//
//  doc_appApp.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

@main
struct doc_appApp: App {
  @StateObject private var bookmarkCollection = BookmarkURLCollectionObject()
  
      @SceneBuilder var body: some Scene {
//        
//      DocumentGroup(newDocument: doc_appDocument()) { file in
//          ContentView(document: file.$document)
//      }
        DocumentGroup(viewing: ClassicDocument.self) { (file) in
          
          return ClassicView(url: file.fileURL, document: file.$document).environmentObject(bookmarkCollection)
        }.commands {
          CommandMenu("Developer Tools"){
            Button("Reset Bookmarks") {
              self.bookmarkCollection.reset()
            }
          }
        }
      }
    
}
