//
//  ImageConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct ImageConversionSetBuilder : ImageConversionSetBuilderProtocol {
  
  public static let defaultBuilders : [ImageConversionSetBuilderProtocol] = []
  public static let sharedInstance:ImageConversionSetBuilderProtocol = ImageConversionSetBuilder()
  
  public let builders : [ImageConversionSetBuilderProtocol]
  
  
  public func buildConversions(forDocument document: SpeculidDocumentProtocol, withConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionSetProtocol? {
        for builder in builders {
          if let conversionSet = builder.buildConversions(forDocument: document, withConfiguration: configuration) {
            return conversionSet
          }
        }
        return nil
  }
  
  public init (builders: [ImageConversionSetBuilderProtocol]? = nil) {
    self.builders = builders ?? ImageConversionSetBuilder.defaultBuilders
  }
}
