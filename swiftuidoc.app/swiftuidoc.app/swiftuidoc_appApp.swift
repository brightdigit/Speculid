import SwiftUI

@main
struct swiftuidoc_appApp: App {
  var body: some Scene {
    DocumentGroup(newDocument: swiftuidoc_appDocument()) { file in
      ContentView(document: file.$document)
    }
  }
}
