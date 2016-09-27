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
    
    guard let size = imageSpecification.size else {
      return nil
    }
    
    guard let convertURL = configuration.convertURL else {
      return .Error(MissingRequiredInstallationError(name: "imagemagick"))
    }
    
    let process = Process()
    
    let destinationURL = specifications.contentsDirectoryURL.appendingPathComponent(specifications.sourceImageURL.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
    let resizeValue = "\(size.width * scale)x\(size.height * scale)"
    
    process.launchPath = convertURL.path
    process.arguments = [specifications.sourceImageURL.path,"-resize",resizeValue,destinationURL.path]
    return .Task(ProcessImageConversionTask(process: process))
  }
  
  
}
