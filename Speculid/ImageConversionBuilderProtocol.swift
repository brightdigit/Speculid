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
    
    guard specifications.sourceImageURL.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame else {
      return nil
    }
    

        var arguments : [String] = ["--without-gui","--export-png"]
        if let size = imageSpecification.size {          
          let dimension = size.height > size.width ? "-h" : "-w"
          let length = Int(round(max(size.width, size.height) * scale))
          let destinationURL = specifications.contentsDirectoryURL.appendingPathComponent(specifications.sourceImageURL.deletingPathExtension().lastPathComponent).appendingPathExtension("\(size.width.cleanValue)x\(size.height.cleanValue).\(scale.cleanValue)x.png")
          arguments.append(contentsOf: [destinationURL.path,dimension,"\(length)", specifications.sourceImageURL.absoluteURL.path])
          //process.waitUntilExit()
        } else {
          // convert to
          let destinationURL = specifications.contentsDirectoryURL.appendingPathComponent(specifications.sourceImageURL.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
          arguments.append(contentsOf: [destinationURL.path, specifications.sourceImageURL.absoluteURL.path])
          
          // if svg
          //process = nil
          // else
          //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
        }
        
        
        //convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null
        let process = Process()
        
        process.launchPath = configuration.inkscapeURL?.path
        process.arguments = arguments
        //process = Process.launchedProcess(launchPath: "/usr/local/bin/inkscape", arguments: arguments)
        return ProcessImageConversionTask(process: process)

    
  }
  
  
}

public struct PDFConversionBuilder : ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    
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

public struct RasterConversionBuilder :ImageConversionBuilderProtocol {
  public func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol? {
    
    guard let scale = imageSpecification.scale else {
      return nil
    }
    
    guard specifications.sourceImageURL.pathExtension.compare("svg", options: .caseInsensitive, range: nil, locale: nil) != .orderedSame else {
      return nil
    }
    
    guard let size = imageSpecification.size else {
      return nil
    }
    
    let process = Process()
    
    let destinationURL = specifications.contentsDirectoryURL.appendingPathComponent(specifications.sourceImageURL.deletingPathExtension().lastPathComponent).appendingPathExtension("\(scale.cleanValue)x.png")
    let resizeValue = "\(size.width * scale)x\(size.height * scale)"
    
    process.launchPath = configuration.convertURL?.path
    process.arguments = [specifications.sourceImageURL.path,"-resize",resizeValue,destinationURL.path]
    return ProcessImageConversionTask(process: process)
  }
  
  
}

public protocol ImageConversionBuilderProtocol {
  func conversion(forImage imageSpecification: ImageSpecification, withSpecifications specifications: SpeculidSpecifications, andConfiguration configuration: SpeculidConfiguration) -> ImageConversionTaskProtocol?
}
