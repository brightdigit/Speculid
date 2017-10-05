//
//  RasterConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

public struct RasterConversionBuilder :ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult? {
    guard let scale = imageSpecification.scale else {
      return nil
    }
    
    guard specifications.sourceImageURL.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) != .orderedSame else {
      return nil
    }
    
    guard let geometry = specifications.geometry else {
      return nil
    }
    
    guard let convertURL = configuration.convertURL else {
      return .Error(MissingRequiredInstallationError(name: "imagemagick"))
    }
    
    let process = Process()
    let resizeValue = geometry.text(scaledBy: Int(scale))    
    process.launchPath = convertURL.path
    process.arguments = [specifications.sourceImageURL.path,"-resize",resizeValue,specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path]
    return .Task(ProcessImageConversionTask(process: process))
  }
  
  
}
