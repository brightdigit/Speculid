//
//  ContentView.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: doc_appDocument

    var body: some View {
      HStack{
        TextEditor(text: $document.text)
        Button("Build") {
          document.build()
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(doc_appDocument()))
    }
}
