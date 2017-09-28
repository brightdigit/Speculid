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

extension SemVer : Hashable {
  public var hashValue: Int {
    return self.description.hashValue
  }
}

public func ==(left: SemVer, right: SemVer) -> Bool {
  return left.major == right.major && left.minor == right.minor && left.patch == right.patch
}

enum Stage : CustomStringConvertible {
  static let all : Set<Stage> = [.alpha, .beta, .production]
  case alpha, beta, production
  
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
  
  init?(string: String) {
    for stage in Stage.all {
      if string.compare(stage.description, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) == ComparisonResult.orderedSame {
        self = stage
        return
      }
    }
    return nil
  }
  
  public static let dictionary: StageBuildDictionaryProtocol! = {    
    guard let url = Bundle.main.url(forResource: "versions", withExtension: "plist") else {
      return StageBuildDictionary(dictionary: StageBuildDictionaryBase())
    }
    
    let data = try! Data(contentsOf: url)
    let plistObj = try! PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.ReadOptions(), format: nil)
    let plist = plistObj as! [String : [String : Int]]
    let dictionary = plist.reduce(StageBuildDictionaryBase(), { (previous, pair) -> StageBuildDictionaryBase in
      var mutable = previous
      mutable[SemVer(versionString: pair.key)!] = pair.value.reduce(
        [Stage : UInt8](),
        {(previous, pair) -> [Stage : UInt8] in
          
          var mutable = previous
          mutable[Stage(string: pair.key)!] = UInt8(pair.value)
          return mutable
      })
      return mutable
    })
    
    return StageBuildDictionary(dictionary: dictionary)
  }()
}

struct StageBuildDictionary : StageBuildDictionaryProtocol {
  
  let dictionary : StageBuildDictionaryBase
  
  func stage(withBuildForVersion version: Version) -> StageBuild? {
    let result = self.dictionary[version.semver]?.filter{
      $0.value <= version.build
      }.max(by: {$0.value < $1.value})
    if let result = result {
      return (stage: result.key, minimum: result.value)
    } else {
      return nil
    }
  }

  public init (dictionary: StageBuildDictionaryBase) {
    self.dictionary = dictionary
  }
}

typealias StageBuildDictionaryBase = [SemVer : [Stage : UInt8]]
typealias StageBuild = (stage: Stage, minimum: UInt8)

protocol StageBuildDictionaryProtocol {
  func stage (withBuildForVersion version: Version) -> StageBuild?
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
  
  var shortDescription:String {
    let stage:Stage
    let build:UInt8?
    if let stagebuild = Stage.dictionary.stage(withBuildForVersion: self) {
      stage = stagebuild.stage
      build = stagebuild.minimum
    } else {
      stage = .production
      build = nil
    }
    switch stage {
    case .production:
      return self.semver.description
    default:
      return "\(self.semver)-\(stage)\(self.build - ((build - 1) ?? 0))"
    }
    
  }
  
  var fullDescription:String {
    let suffix = (Double(self.build) + (Double(self.versionControl?.TICK ?? 0) + self.extra/1000.0)/10000.0)/100.0
    let suffixString = formatter.string(for: suffix)!.components(separatedBy: ".")[1]
    return "\(self.semver)\(suffixString)"
  }
  
  public var description:String {
    return self.fullDescription
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
        let rangeIndex = parameter.range(from: match.range(at: 1))
        if let param = CommandLineParameter(rawValue: parameter.substring(with: rangeIndex!)) {
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
