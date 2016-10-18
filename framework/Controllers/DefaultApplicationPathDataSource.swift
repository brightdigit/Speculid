//
//  DefaultApplicationPathDataSource.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public struct DefaultApplicationPathDataSource : ApplicationPathDataSource {
   public static let defaultPaths : [ApplicationPath : String] = [.inkscape : "/usr/local/bin/inkscape", .convert :  "/usr/local/bin/convert"]
  
  public func applicationPaths(oldPaths: ApplicationPathDictionary?) -> ApplicationPathDictionary {
    var applicationPaths = ApplicationPathDictionary()
    for pair in DefaultApplicationPathDataSource.defaultPaths {
        if let url = FileManager.default.url(ifExistsAtPath: pair.value) {
          applicationPaths[pair.key] = url
        }
    }
    return applicationPaths
  }
}
