//
//  SpeculidConfigurationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

public protocol SpeculidConfigurationProtocol {
  var applicationPaths : ApplicationPathDictionary { get }
}

public extension SpeculidConfigurationProtocol {
  var inkscapeURL : URL? {
    return self.applicationPaths[.inkscape]
  }
  
  var convertURL : URL? {
    return self.applicationPaths[.convert]
  }
}
