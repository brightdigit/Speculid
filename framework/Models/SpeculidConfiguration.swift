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
  public static let main = SpeculidConfiguration()
  
  public let inkscapeURL : URL?
  public let convertURL : URL?
  
  public init () {
    self.inkscapeURL = FileManager.default.url(ifExistsAtPath: "/usr/local/bin/inkscape")
    self.convertURL =  FileManager.default.url(ifExistsAtPath: "/usr/local/bin/convert")
  }
}
