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
  @available (*, deprecated: 1.1.0, message: "Use library instead.")
  var inkscapeURL : URL? {
    return self.applicationPaths[.inkscape]
  }
  
  @available (*, deprecated: 1.1.0, message: "Use library instead.")
  var convertURL : URL? {
    return self.applicationPaths[.convert]
  }
}
