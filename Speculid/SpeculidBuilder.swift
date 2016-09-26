//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct SpeculidBuilder : SpeculidBuilderProtocol {
  public static let shared = SpeculidBuilder(configuration: SpeculidConfiguration.main)
  public let configuration: SpeculidConfiguration
  
  public func build (document: SpeculidDocument, callback: ((Error?) -> Void)) {
    
    let tasks = document.images.flatMap{ (image) -> ImageConversionTaskProtocol? in
      return ImageConversionBuilder.sharedInstance.conversion(forImage: image, withSpecifications: document.specifications, andConfiguration: self.configuration)
      
    }
    
  }
}
