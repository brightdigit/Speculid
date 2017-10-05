//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

@available(*, deprecated: 2.0.0)
public struct CollectionConversion : ImageConversionSetProtocol {
  let tasks : [ImageConversionTaskProtocol]
  
  public func run(_ callback: @escaping (Error?) -> Void) {
    var errors = [Error]()
    
    let group = DispatchGroup()
    
    for task in tasks {
        group.enter()
        task.start{error in
          if let error = error {
            errors.append(error)
          }
          group.leave()
        }
    }
    
    group.notify(queue: .global()) {
      callback(ArrayError.error(for: errors))
    }
    
  }
}
