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
    
    let removeAlphaProcess: Process?
    
    guard let scale = imageSpecification.scale else {
      return nil
    }
    
    guard specifications.sourceImageURL.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame else {
      return nil
    }
    
    guard let inkscapeURL = configuration.inkscapeURL else {
      return .Error(MissingRequiredInstallationError(name: "inkscape"))
    }
    
    let temporaryUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(UUID().uuidString)
    
    let inkScapeDestinationPath = specifications.removeAlpha ? temporaryUrl.path : specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path
    
    if specifications.removeAlpha {
      if let convertURL = configuration.convertURL {
      let process = Process()
      process.launchPath = convertURL.path
      process.arguments = [inkScapeDestinationPath,"-alpha","remove","-alpha","off",specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path]
      removeAlphaProcess = process
      } else {
        return .Error(MissingRequiredInstallationError(name: "imagemagick"))
      }
    } else {
      removeAlphaProcess = nil
    }
    
    var arguments : [String] = ["--without-gui","--export-png", inkScapeDestinationPath]
    
    
    if let background = specifications.background {
      arguments.append(contentsOf: ["-b", background.hexString(false), "-y", "\(background.alphaComponent)"])
    }
    
    if let size = imageSpecification.size {
      let dimension = size.height > size.width ? "-h" : "-w"
      let length = Int(round(max(size.width, size.height) * scale))
      arguments.append(contentsOf: [dimension,"\(length)", specifications.sourceImageURL.absoluteURL.path])
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
      arguments.append(contentsOf: [dimension,"\(Int(length))", specifications.sourceImageURL.absoluteURL.path])
    } else {
      // convert to
      arguments.append(contentsOf: ["-d", "\(90*scale)" ,specifications.sourceImageURL.absoluteURL.path])
    }
    
    //
    
    
    let process = Process()
    process.launchPath = inkscapeURL.path
    process.arguments = arguments
    print(arguments.joined(separator: " "))
    
    if let removeAlphaProcess = removeAlphaProcess {
      return .Task(ProcessImageConversionTask(process: SerialProcess(processes: [process, removeAlphaProcess]) ))
    } else {
      return .Task(ProcessImageConversionTask(process: process))
    }
  }
}
