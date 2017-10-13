//
//  ImageConversionBuilderProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

public protocol ImageConversionBuilderProtocol {
  func conversion(forImage imageSpecification: AssetSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult?
}
