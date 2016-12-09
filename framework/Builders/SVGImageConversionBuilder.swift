//
//  SVGImageConversionBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

public struct SVGImageConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult? {
    guard let scale = imageSpecification.scale else {
      return nil
    }
    
    guard specifications.sourceImageURL.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame else {
      return nil
    }
    
    guard let inkscapeURL = configuration.inkscapeURL else {
      return .Error(MissingRequiredInstallationError(name: "inkscape"))
    }
    
    var arguments : [String] = ["--without-gui","--export-png"]
    if let size = imageSpecification.size {
      let dimension = size.height > size.width ? "-h" : "-w"
      let length = Int(round(max(size.width, size.height) * scale))
      arguments.append(contentsOf: [specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path,dimension,"\(length)", specifications.sourceImageURL.absoluteURL.path])
    } else if let geometryValue = specifications.geometry?.value {
      let dimension: String
      let length: CGFloat
      switch geometryValue {
      case .Width(let value):
        dimension = "-w"
        length = CGFloat(value) * scale
      case .Height(let value):
        dimension = "-h"
        length = CGFloat(value) * scale
      }
      arguments.append(contentsOf: [specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path,dimension,"\(Int(length))", specifications.sourceImageURL.absoluteURL.path])
    } else {
      // convert to
      arguments.append(contentsOf: [specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path, "-d", "\(90*scale)" ,specifications.sourceImageURL.absoluteURL.path])
    }
    
    let process = Process()
    process.launchPath = inkscapeURL.path
    process.arguments = arguments
    return .Task(ProcessImageConversionTask(process: process))
  }
}
