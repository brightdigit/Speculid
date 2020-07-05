//
//  doc_appApp.swift
//  doc-app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

@main
struct doc_appApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: doc_appDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
