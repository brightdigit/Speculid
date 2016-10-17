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
}

extension FileManager {
  func url (ifExistsAtPath path: String) -> URL? {
    return FileManager.default.fileExists(atPath: path) ? URL(fileURLWithPath: path) : nil
  }
}

public typealias ApplicationPathDictionary = [ApplicationPath : URL]

public struct SpeculidConfiguration : SpeculidConfigurationProtocol {
  public let applicationPaths : ApplicationPathDictionary
  
  public init (applicationPaths : ApplicationPathDictionary) {
    self.applicationPaths = applicationPaths
  }
}
