//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

struct ClassicView: View {
    @Binding var document: ClassicDocument

    var body: some View {
      HStack{
        TextEditor(text: $document.text)
        Button("Build") {
          document.build()
        }
      }
    }
}

struct ClassicView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(doc_appDocument()))
    }
}
