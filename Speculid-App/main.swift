//
//  main.swift
//  speculid
//
//  Created by Leo Dion on 9/27/16.
//
//

import Foundation
import Speculid
import SwiftVer

public enum CommandLineParameter : String {
  case Help = "help", Version = "version"
}

let output = FileHandle.standardOutput

let regex = try! NSRegularExpression(pattern: "\\-\\-(\\w+)", options: [])
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
  } else if let parameter = CommandLine.arguments.dropFirst().first {
    let range = NSRange(0..<parameter.characters.count)
    let match = regex.firstMatch(in: parameter, options: [], range: range)
    let rangeIndex = parameter.range(from: match!.rangeAt(1))
    if let param = CommandLineParameter(rawValue: parameter.substring(with: rangeIndex!)) {
      switch param {
      case .Version :
        output.write(Speculid.version.debugDescription.data(using: .utf8)!)
        output.write("example".data(using: .utf8)!)
        print("test")
        break
      default:
        break
      }
    }
  }
}
exit(0)
