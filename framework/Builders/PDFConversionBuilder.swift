//
//  PDFConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

public struct PDFConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult? {
    
    if imageSpecification.scale != nil {
      return nil
    }
    
    guard let inkscapeURL = configuration.inkscapeURL else {
      return .Error(MissingRequiredInstallationError(name: "inkscape"))
    }
    
    let process = Process()
    
    process.launchPath = inkscapeURL.path
    process.arguments = ["--without-gui","--export-area-drawing","--export-pdf",
                        specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path,specifications.sourceImageURL.absoluteURL.path]
    
    return .Task(ProcessImageConversionTask(process: process))
  }
}
