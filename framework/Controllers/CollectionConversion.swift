//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

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
//
//
//public extension SpeculidBuilderProtocol {
//  func build(document : SpeculidDocumentProtocol) -> Error? {
//    var result: Error?
//    let semaphone = DispatchSemaphore(value: 0)
//    self.build(document: document) { (error) in
//      result = error
//      semaphone.signal()
//    }
//    semaphone.wait()
//    return result
//  }
//}

