//
//  SpeculidConfigurationLoader.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public struct SpeculidConfigurationLoader : SpeculidConfigurationLoaderProtocol {
  
  let dataSources : [ApplicationPathDataSource]
  
  public init (dataSources : [ApplicationPathDataSource]) {
    self.dataSources = dataSources
  }
  
  public func load(_ closure: @escaping (SpeculidConfigurationProtocol) -> Void) {
    DispatchQueue.main.async {
      var applicationPaths = ApplicationPathDictionary()
      
      for dataSource in self.dataSources {
        let newPaths = dataSource.applicationPaths(oldPaths: applicationPaths)
        for (type, url) in newPaths {
          if applicationPaths[type] == nil {
            applicationPaths[type] = url
          }
        }
      }
      
      closure(SpeculidConfiguration(applicationPaths: applicationPaths))
    }
  }
}
