//
//  ImageConversionBuilderProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct SVGImageConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    guard let scale = imageSpecification.scale else {
      return nil
    }
    
    guard specifications.sourceImageUrl.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame else {
      return nil
    }
    
    if let scale = imageSpecification.scale {
      if specifications.sourceImageUrl.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame {
        var arguments : [String] = ["--without-gui","--export-png"]
        if let size = imageSpecification.size {
          
          let dimension = size.height > size.width ? "-h" : "-w"
          let length = Int(round(max(size.width, size.height) * scale))
          let destinationURL = specifications.contentsDirectoryUrl.appendingPathComponent(specifications.sourceImageUrl.deletingPathExtension().lastPathComponent).appendingPathExtension("\(size.width.cleanValue)x\(size.height.cleanValue).\(scale.cleanValue)x.png")
          arguments.append(contentsOf: [destinationURL.path,dimension,"\(length)", specifications.sourceImageUrl.absoluteURL.path])
          //process.waitUntilExit()
        } else {
          // convert to
          let destinationURL = specifications.contentsDirectoryUrl.appendingPathComponent(specifications.sourceImageUrl.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
          arguments.append(contentsOf: [destinationURL.path, specifications.sourceImageUrl.absoluteURL.path])
          
          // if svg
          //process = nil
          // else
          //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
        }
        
        
        //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
        let process = Process()
        //process.launchPath = configuration.inkscapePath
        process.arguments = arguments
        //process = Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments: arguments)
        
      }
    }
    
    return nil
  }
  
  
}

public struct PDFConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    return nil
  }
  
  
}

public struct RasterConversionBuilder :ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    return nil
  }
  
  
}

public protocol ImageConversionBuilderProtocol {
  func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol?
}
