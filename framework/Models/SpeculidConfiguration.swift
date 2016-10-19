//
//  File.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

extension FileManager {
  func url (ifExistsAtPath path: String) -> URL? {
    return FileManager.default.fileExists(atPath: path) ? URL(fileURLWithPath: path) : nil
  }
}

public struct SpeculidConfiguration : SpeculidConfigurationProtocol {
  public let applicationPaths : ApplicationPathDictionary
  
  public init (applicationPaths : ApplicationPathDictionary? = nil) {
    self.applicationPaths = applicationPaths ?? ApplicationPathDictionary()
  }
}
