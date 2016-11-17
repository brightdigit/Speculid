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


enum Stage : CustomStringConvertible {
  case alpha, beta, production
  
  public static func current (for version: Version) -> Stage {
    let result = self.minimumBuildVersions.filter{
      $0.value < version.build
      }.max(by: {$0.value < $1.value})
    return result?.key ?? .alpha
  }
  
  static let minimumBuildVersions : [Stage: UInt8] = [.beta : 15, .production : 17]
  
  var description: String {
    switch self {
    case .alpha:
      return "alpha"
    case .beta:
      return "beta"
    case .production:
      return "production"
    }
  }
  
  var minimumBuildVersion : UInt8? {
    return type(of: self).minimumBuildVersions[self]
  }
}

func -(a: UInt8?, b: UInt8?) -> UInt8? {
  guard let a = a, let b = b else {
    return nil
  }
  return a - b
}

extension Version : CustomStringConvertible {
  public var extra:Double {
    if let extraString = self.versionControl?.EXTRA {
      return Double(extraString) ?? 0
    } else {
      return 0
    }
  }
  public var description:String {
    let suffix = (Double(self.build) + (Double(self.versionControl?.TICK ?? 0) + self.extra/1000.0)/10000.0)/100.0
    let suffixString = formatter.string(for: suffix)!.components(separatedBy: ".")[1]
    return "\(self.semver)\(suffixString)"
  }
  func descriptionWithStage (_ stage: Stage) -> String {
    switch stage {
    case .production:
      return self.semver.description
    default:
      return "\(self.semver)-\(stage)\(self.build - ((stage.minimumBuildVersion - 1) ?? 0))"
    }
  }
}

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
        let rangeIndex = parameter.range(from: match.rangeAt(1))
        if let param = CommandLineParameter(rawValue: parameter.substring(with: rangeIndex!)) {
          switch param {
          case .Version :
            print("Speculid v\(speculid.version.descriptionWithStage(Stage.current(for: speculid.version))) [\(speculid.version)]")
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
