//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public typealias ImageConversionPair = (image: ImageSpecificationProtocol,conversion: ConversionResult?)
public typealias ImageConversionDictionary = [String:ImageConversionPair]

extension SpeculidSpecificationsProtocol {
  public func destination(forImage image: ImageSpecificationProtocol) -> String {
    if let filename = image.filename {
      return filename
    } else if let scale = image.scale {
      if let size = image.size {
        return self.sourceImageURL.deletingPathExtension().appendingPathExtension("\(size.width.cleanValue)x\(size.height.cleanValue)@\(scale.cleanValue)x~\(image.idiom.rawValue).png").lastPathComponent
      } else {
        return self.sourceImageURL.deletingPathExtension().appendingPathExtension("\(scale.cleanValue)x~\(image.idiom.rawValue).png").lastPathComponent
      }
    } else {
      return self.sourceImageURL.deletingPathExtension().appendingPathExtension("pdf").lastPathComponent
    }
  }
}

public struct SpeculidBuilder : SpeculidBuilderProtocol {
  
  public let tracker : AnalyticsTrackerProtocol?
  public let configuration: SpeculidConfigurationProtocol
  
  public func build (document: SpeculidDocumentProtocol, callback: @escaping ((Error?) -> Void)) {
    let start = Date()
    var errors = [Error]()
    
    let taskDictionary = document.images.reduce(ImageConversionDictionary()) { (dictionary, image) -> ImageConversionDictionary in
      let conversion = ImageConversionBuilder.sharedInstance.conversion(forImage: image, withSpecifications: document.specifications, andConfiguration: self.configuration)
      var dictionary = dictionary
      let destinationFileName = document.specifications.destination(forImage: image)
      dictionary[destinationFileName] = ImageConversionPair(image: image, conversion: conversion)
      return dictionary
    }
    
    let group = DispatchGroup()
    
    for entry in taskDictionary {
      if let conversion = entry.value.conversion, case .Task(let task) = conversion {
        group.enter()
        task.start{error in
          if let error = error {
            errors.append(error)
          }
          group.leave()
        }
      }
    }
    
    group.notify(queue: .global()) {
      let difference = -start.timeIntervalSinceNow
      self.tracker?.track(time: difference, withCategory: "operations", withVariable: "building", withLabel: nil)
      //self.tracker?.trackTiming(ofCategory: "Timing", variable: "Build Process Time", time: NSNumber(value: difference), label: "")
      callback(ArrayError.error(for: errors))
    }
    
  }
}


public extension SpeculidBuilderProtocol {
  func build(document : SpeculidDocumentProtocol) -> Error? {
    var result: Error?
    let semaphone = DispatchSemaphore(value: 0)
    self.build(document: document) { (error) in
      result = error
      semaphone.signal()
    }
    semaphone.wait()
    return result
  }
}
