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
      
      var valuesSet = false
      let queue = DispatchQueue(label: Speculid.bundle.bundleIdentifier!+".configuration.queue")
      var applicationPaths = ApplicationPathDictionary()
      
      for dataSource in self.dataSources {
        queue.sync(execute: {
          if valuesSet {
            return
          }
          dataSource.applicationPaths({ (paths) in
            for (type, url) in paths {
              if applicationPaths[type] == nil {
                applicationPaths[type] = url
              }
            }
            var allSet = true
            for type in ApplicationPath.values {
              if applicationPaths[type] == nil {
                allSet = false
                break
              }
            }
            valuesSet = allSet
          })
        })
      }
      
      closure(SpeculidConfiguration(applicationPaths: applicationPaths))
    }
  }
}
