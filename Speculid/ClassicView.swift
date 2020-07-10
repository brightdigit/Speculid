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

    var body: some View {
      HStack{
        Text(document.document.assetDirectoryRelativePath)
        Button("Build") {
          document.build()
        }
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
      ClassicView(document: .constant(ClassicDocument()))
    }
}
