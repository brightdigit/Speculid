//
//  doc_appApp.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

@main
struct doc_appApp: App {
      @SceneBuilder var body: some Scene {
        
      DocumentGroup(newDocument: doc_appDocument()) { file in
          ContentView(document: file.$document)
      }
        DocumentGroup(viewing: ClassicDocument.self) { (file) in
          ClassicView(document: file.$document, fileURL: file.fileURL)
        }
          }
    
}
