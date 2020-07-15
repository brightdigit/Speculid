//
//  swiftuidoc_appApp.swift
//  swiftuidoc.app
//
//  Created by Leo Dion on 7/4/20.
//

import SwiftUI

@main
struct swiftuidoc_appApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: swiftuidoc_appDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
