//
//  ImageConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct ImageConversionBuilder : ImageConversionBuilderProtocol {
  public static let sharedInstance:ImageConversionBuilderProtocol = ImageConversionBuilder()
  
  public let builders : [ImageConversionBuilderProtocol] = [PDFConversionBuilder(), SVGImageConversionBuilder(), RasterConversionBuilder()]
  
  public func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionTaskProtocol? {
    for builders in builders {
      if let conversion = builders.conversion(forImage: imageSpecification, withSpecifications: specifications, andConfiguration: configuration) {
        return conversion
      }
    }
    return nil
  }
}
