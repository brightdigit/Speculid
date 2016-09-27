//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct ArrayError : Error {
  public let errors : [Error]
  
  public static func error (for errors: [Error]) -> Error? {
    if errors.count > 1 {
      return ArrayError(errors: errors)
    } else {
      return errors.first
    }
  }
}

public struct SpeculidBuilder : SpeculidBuilderProtocol {
  public static let shared = SpeculidBuilder(configuration: SpeculidConfiguration.main)
  public let configuration: SpeculidConfiguration
  
  public func build (document: SpeculidDocumentProtocol, callback: @escaping ((Error?) -> Void)) {
    
    var errors = [Error]()
    let tasks = document.images.flatMap{ (image) -> ImageConversionTaskProtocol? in
      return ImageConversionBuilder.sharedInstance.conversion(forImage: image, withSpecifications: document.specifications, andConfiguration: self.configuration)
      
    }
    
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
