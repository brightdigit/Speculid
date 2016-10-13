//
//  SpeculidApplication.swift
//  speculid
//
//  Created by Leo Dion on 10/13/16.
//
//

import Foundation
import SwiftVer

public struct SpeculidApplication : SpeculidApplicationProtocol {
  let configuration : SpeculidConfigurationProtocol
  
  public func document (url: URL) -> SpeculidDocumentProtocol? {
    return SpeculidDocument(url: url, configuration: configuration)
  }
  
  public var builder : SpeculidBuilderProtocol {
    return SpeculidBuilder(configuration: configuration)
  }
  
  public var version : Version {
    return Speculid.version
  }
  
}
