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
  let url : URL?
    @Binding var document: ClassicDocument
  @EnvironmentObject var bookmarkCollection : BookmarkURLCollectionObject
  @Environment(\.importFiles) var importFiles
  
  var canBuild : Bool {
    return url != nil &&
      
        self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath) &&
      self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.sourceImageRelativePath)
  }
    var body: some View {
      VStack{
        Text(url?.absoluteString ?? "")
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
          }
        }, label: {
          HStack{
            Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.sourceImageRelativePath) ? "lock.open.fill" : "lock.fill")
            Image(systemName: "photo.fill")
            Text(self.document.document.sourceImageRelativePath)
          }
        })
        
          Button(action: {
            
            self.importFiles(singleOfType: [.directory]) { (result) in
              guard case let .success(url) = result else {
                return
              }
              guard url.path == self.url?.deletingLastPathComponent().appendingPathComponent(self.document.document.assetDirectoryRelativePath).path else {
                return
              }
              let saveResult = Result{ try fileManagement.saveBookmark(url) }
                /*.flatMap{
                Result{ try fileManagement.saveBookmark(jsonURL)}
              }*/
              guard case .success = saveResult else {
                debugPrint(saveResult)
                return
              }
              let urlResult = Result{ try fileManagement.bookmarkURL(fromURL: url) }
//              let jsonURLResult = Result{ try fileManagement.bookmarkURL(fromURL: jsonURL) }
//              debugPrint(jsonURLResult)
            }
          }, label: {
            HStack{
              Image(systemName: self.bookmarkCollection.isAvailable(basedOn: self.url, relativePath: self.document.document.assetDirectoryRelativePath) ? "lock.open.fill" : "lock.fill")
              Image(systemName: "photo.fill")
              Text(self.document.document.assetDirectoryRelativePath)
            }
          })
        
          
        Toggle("Remove Alpha", isOn: self.$document.document.removeAlpha)
        ColorPicker("Background Color", selection: self.$document.document.backgroundColor)
       
        Button("Build") {
          if let url = self.url {
            
            self.document.build(fromURL: url)
          }
        }.disabled(!self.canBuild)
        
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(url: nil, document: .constant(ClassicDocument())).environmentObject(BookmarkURLCollectionObject())
    }
}
