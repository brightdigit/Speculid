//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI
import SpeculidKit

struct ClassicView: View {
  let fileManagement = FileManagement()
    @Binding var document: ClassicDocument
  @State var fileURL: URL?
  @Environment(\.importFiles) var importFiles
    var body: some View {
      VStack{
        Button(action: {
          self.importFiles(singleOfType: [.svg, .png]) { (result) in
            guard case let .success(url) = result else {
              return
            }
            let saveResult = Result{ try fileManagement.saveBookmark(url) }
            guard case .success = saveResult else {
              return
            }
            let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
            debugPrint(urlResult)
          }
        }, label: {
          HStack{
            Image(systemName: "photo.fill")
            Text(document.document.sourceImageRelativePath)
          }
        })
        
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
