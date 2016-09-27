//
//  main.swift
//  speculid
//
//  Created by Leo Dion on 9/27/16.
//
//

import Foundation
import Speculid

let speculidURL: URL?

if let path = CommandLine.arguments.last , CommandLine.arguments.count > 1 {
  speculidURL = URL(fileURLWithPath: path)
} else {
  let openPanel = NSOpenPanel()
  openPanel.allowsMultipleSelection = false
  openPanel.canChooseDirectories = false
  openPanel.canChooseFiles = true
  openPanel.allowedFileTypes = ["spcld"]
  openPanel.runModal()
  openPanel.title = "Select File"
  speculidURL = openPanel.url
  openPanel.close()
}

if let speculidURL = speculidURL {
  if let document = SpeculidDocument(url: speculidURL) {
    if let error = SpeculidBuilder.shared.build(document: document) {
      print(error)
      exit(1)
    }
  }
}
