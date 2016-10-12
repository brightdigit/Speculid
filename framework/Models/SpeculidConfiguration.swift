//
//  File.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public enum ApplicationPath : String {
  case inkscape = "inkscape",
  convert  = "convert"
  
  public static let defaultPaths : [ApplicationPath : String] = [.inkscape : "/usr/local/bin/inkscape", .convert :  "/usr/local/bin/convert"]
  
}

extension FileManager {
  func url (ifExistsAtPath path: String) -> URL? {
    return FileManager.default.fileExists(atPath: path) ? URL(fileURLWithPath: path) : nil
  }
}

public typealias ApplicationPathDictionary = [ApplicationPath : URL]

public struct SpeculidConfiguration : SpeculidConfigurationProtocol {
  public static let main = SpeculidConfiguration()
  
  public let applicationPaths : ApplicationPathDictionary
  
  public var inkscapeURL : URL? {
    return self.applicationPaths[ApplicationPath.inkscape]
  }
  
  public var convertURL : URL? {
    return self.applicationPaths[ApplicationPath.convert]
  }
  
  public struct SearchPaths {
    public static let defaultSearchPaths = [FileManager.default.currentDirectoryPath, NSHomeDirectory()]
    public static let defaultConfigurationName = "speculid.json"
    public static let keyName = "paths"
    
    public static func urls (in searchPaths: [String]? = nil, for fileName: String? = nil) -> [ApplicationPath: URL] {
      let fileName = fileName ?? self.defaultConfigurationName
      
      var checked = [String]()
      var result = [ApplicationPath: URL]()
      
      var paths = self.defaultSearchPaths
      if let searchPaths = searchPaths {
        paths.append(contentsOf: searchPaths)
      }
      paths.sort()
      
      while let path = paths.popLast() {
        var url = URL(fileURLWithPath: path)
        while (url.path != NSOpenStepRootDirectory() && !paths.contains(url.path) && !checked.contains(url.path)) {
          let configUrl = url.appendingPathComponent(fileName)
          
          guard let configJSONData = try? Data(contentsOf: configUrl) else {
            break
          }
          
          guard let configJSON = (try? JSONSerialization.jsonObject(with: configJSONData, options: [])) as? [String : Any] else {
            break
          }
          
          guard let pathsDictionary = configJSON[self.keyName] as? [String:String] else {
            break
          }
          
          for pair in pathsDictionary {
            if let appPathEnum = ApplicationPath(rawValue: pair.key) , result[appPathEnum] == nil {
              result[appPathEnum] = FileManager.default.url(ifExistsAtPath: pair.value)
            }
          }
          
          checked.append(url.path)
          url.deleteLastPathComponent()
        }
      }
      return result
    }
  }
  
  
  public init () {
    var applicationPaths = SearchPaths.urls()
    
    for pair in ApplicationPath.defaultPaths {
      if applicationPaths[pair.key] == nil, let url = FileManager.default.url(ifExistsAtPath: pair.value) {
        applicationPaths[pair.key] = url
      }
    }
    
    self.applicationPaths = applicationPaths
  }
}
