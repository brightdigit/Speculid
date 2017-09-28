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

protocol ResourceSource {
  func url(forResource name: String?, withExtension ext: String?) -> URL?
}

extension String : ResourceSource {
  func url(forResource name: String?, withExtension ext: String?) -> URL? {
    if let bundle = Bundle(path: self){
      if let url = bundle.url(forResource: name, withExtension: ext) {
        return url
      } else {
        return bundle.executablePath?.url(forResource: name, withExtension: ext)
      }
    } else if let destinationPath = try? FileManager.default.destinationOfSymbolicLink(atPath: self) {
      return URL(fileURLWithPath: self).deletingLastPathComponent().appendingPathComponent(destinationPath).path.url(forResource: name, withExtension: ext)
    } else if FileManager.default.isExecutableFile(atPath: self) {
      var url = URL(fileURLWithPath: self).deletingLastPathComponent()
      while url.path != "/" {
        if let bundle = Bundle(url: url), let resourceUrl = bundle.url(forResource: name, withExtension: ext) {
          return resourceUrl
        }
        url.deleteLastPathComponent()
      }
    }
    return nil
  }
}


let formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.minimumFractionDigits = 9
  formatter.minimumIntegerDigits = 1
  return formatter
}()

public enum CommandLineParameter : String {
  case Help = "help", Version = "version"
}

extension Array: SpeculidArgumentsProtocol {
  
}

Speculid.begin(withArguments: CommandLine.arguments,{
  (speculid) in
  
  let helpText = try! String(contentsOf: Bundle.main.bundlePath.url(forResource: "help", withExtension: "txt")!)
  
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
    openPanel.allowedFileTypes = ["spcld","speculid"]
    openPanel.runModal()
    openPanel.title = "Select File"
    speculidURL = openPanel.url
    openPanel.close()
  }
  
  if let speculidURL = speculidURL {
    if let document = speculid.document(url: speculidURL) {
      if let error = speculid.builder.build(document: document) {
        print(error)
        exit(1)
      }
    } else if let parameter = CommandLine.arguments.dropFirst().first {
      let range = NSRange(0..<parameter.characters.count)
      if let match = regex.firstMatch(in: parameter, options: [], range: range) {
        if let range = Range(match.range(at: 1), in: parameter), let param = CommandLineParameter(rawValue: String(parameter[range])) {
          switch param {
          case .Version :
            
            print("Speculid v\(speculid.version.shortDescription) [\(speculid.version)]")
            break
          default:
            print(helpText)
            break
          }
        }
      }
    }
  }
  exit(0)
})

// TODO: use a semaphore
RunLoop.main.run()
