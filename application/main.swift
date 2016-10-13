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
import GoogleAnalyticsTracker

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

let helpText = try! String(contentsOf: Bundle.main.bundlePath.url(forResource: "help", withExtension: "txt")!)

let formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.minimumFractionDigits = 9
  formatter.minimumIntegerDigits = 1
  return formatter
}()

enum Stage : CustomStringConvertible {
  case alpha, beta, production
  
  @available(*, deprecated: 1.0.0, message: "Preprocessor directive should be replaced. Instead use build number minimum.")
  static var current : Stage {
  #if ALPHA
    return .alpha
  #elseif BETA
    return .beta
  #else
    return .production
  #endif
  }
  
  static let minimumBuildVersions : [Stage: UInt8] = [.beta : 15]
  
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
  if let document = SpeculidDocument(url: speculidURL) {
    if let error = SpeculidBuilder.shared.build(document: document) {
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
          print("Speculid v\(Speculid.version.descriptionWithStage(Stage.current)) [\(Speculid.version)]")
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
