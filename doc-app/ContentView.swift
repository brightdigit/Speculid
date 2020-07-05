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
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(doc_appDocument()))
    }
}
