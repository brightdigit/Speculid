//
//  PDFConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

public struct PDFConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionTaskProtocol? {
    
    if imageSpecification.scale != nil {
      return nil
    }
    
    let destinationURL = specifications.contentsDirectoryURL.appendingPathComponent(specifications.sourceImageURL.deletingPathExtension().lastPathComponent).appendingPathExtension("pdf")
    let process = Process()
    
    process.launchPath = configuration.inkscapeURL?.path
    process.arguments = ["--without-gui","--export-area-drawing","--export-pdf",destinationURL.path,specifications.sourceImageURL.absoluteURL.path]
    
    return ProcessImageConversionTask(process: process)
    //Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments: ["--without-gui","--export-area-drawing","--export-pdf",destinationURL.path,self.specifications.sourceImageURL.absoluteURL.path])
    
    
  }
}
