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
      var applicationPathSets = Array(repeating: ApplicationPathDictionary(), count: self.dataSources.count)
      let group = DispatchGroup()
      
      /*
      DispatchQueue.main.async(group: group, qos: DispatchQoS.default, flags: DispatchWorkItemFlags(), execute: { 
        
      })
 */
      
      
      for (index,dataSource) in self.dataSources.enumerated() {
        group.enter()
        dataSource.applicationPaths({ (newPaths) in
          applicationPathSets[index] = newPaths
          group.leave()
        })
      }
      
      var applicationPaths = ApplicationPathDictionary()
      group.notify(queue: .main, execute: { 
        for paths in applicationPathSets {
          
          for (type, url) in paths {
            if applicationPaths[type] == nil {
              applicationPaths[type] = url
            }
          }
        }
        
        closure(SpeculidConfiguration(applicationPaths: applicationPaths))
      })
    }
  }
}
