//
//  ImageConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct ImageConversionBuilder : ImageConversionBuilderProtocol {
  public static let sharedInstance:ImageConversionBuilderProtocol = ImageConversionBuilder(builders: [ImageConversionBuilderProtocol]())
  
  public let builders : [ImageConversionBuilderProtocol]
  
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    for builders in builders {
      if let conversion = builders.conversion(forImage: imageSpecification, withSpecifications: specifications, andConfiguration: configuration) {
        return conversion
      }
    }
    return nil
  }
}
