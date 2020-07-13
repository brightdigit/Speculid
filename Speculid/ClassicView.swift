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
            Text(self.document.document.sourceImageRelativePath)
          }
        })
        
          Button(action: {
            self.importFiles(singleOfType: [.json]) { (result) in
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
              Text(self.document.document.assetDirectoryRelativePath)
            }
          })
        
        Toggle("Remove Alpha", isOn: self.$document.document.removeAlpha)
        ColorPicker("Background Color", selection: self.$document.document.backgroundColor)
       
        
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(document: .constant(ClassicDocument()))
    }
}
