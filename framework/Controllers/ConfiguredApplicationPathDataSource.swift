//
//  ConfiguredApplicationPathDataSource.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public struct ConfiguredApplicationPathDataSource : ApplicationPathDataSource {
  public func applicationPaths(_ closure: @escaping (ApplicationPathDictionary) -> Void) {
    closure(ConfiguredApplicationPathDataSource.urls(in: self.searchPaths, for: self.fileName))
  }

  
  public let searchPaths:[String]
  public let fileName: String
  
  public static let defaultSearchPaths = [FileManager.default.currentDirectoryPath, NSHomeDirectory()]
  public static let defaultConfigurationName = "speculid.json"
  public static let keyName = "paths"
  
  public init (searchPaths : [String]? = nil, fileName: String? = nil) {
    self.searchPaths = searchPaths ?? ConfiguredApplicationPathDataSource.defaultSearchPaths
    self.fileName = fileName ?? ConfiguredApplicationPathDataSource.defaultConfigurationName
  }
  
  public static func urls (in searchPaths: [String], for fileName: String) -> [ApplicationPath: URL] {
    
    
    var checked = [String]()
    var result = [ApplicationPath: URL]()
    
    var paths = self.defaultSearchPaths
    paths.append(contentsOf: searchPaths)
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
