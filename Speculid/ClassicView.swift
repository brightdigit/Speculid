//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import SpeculidKit

struct ClassicView: View {
    @Binding var document: ClassicDocument
  var fileURL: URL?

    var body: some View {
      HStack{
        Text(document.document.assetDirectoryRelativePath)
        self.fileURL.map{
          fileURL in
          Button("Build") {
            document.build(fromURL: fileURL)
          }
        }
        
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(document: .constant(ClassicDocument()), fileURL: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
    }
}
