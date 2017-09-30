//
//  SpeculidBuilder.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct CollectionConversionBuilder : ImageConversionSetBuilderProtocol {

public func buildConversions(forDocument document: SpeculidDocumentProtocol, withConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionSetProtocol? {
    var errors = [Error]()
    
    let taskDictionary = document.images.reduce(ImageConversionDictionary()) { (dictionary, image) -> ImageConversionDictionary in
      let conversion = ImageConversionBuilder.sharedInstance.conversion(forImage: image, withSpecifications: document.specifications, andConfiguration: configuration)
      var dictionary = dictionary
      let destinationFileName = document.specifications.destination(forImage: image)
      dictionary[destinationFileName] = ImageConversionPair(image: image, conversion: conversion)
      return dictionary
    }
  
  let tasks = taskDictionary.flatMap { (pair) -> ImageConversionTaskProtocol? in
    guard let conversion = pair.value.conversion, case .Task(let task) = conversion else {
      return nil
    }
    
    return task
  }
    
  return CollectionConversion(tasks: tasks)
    
  }
}
//
//
//public extension SpeculidBuilderProtocol {
//  func build(document : SpeculidDocumentProtocol) -> Error? {
//    var result: Error?
//    let semaphone = DispatchSemaphore(value: 0)
//    self.build(document: document) { (error) in
//      result = error
//      semaphone.signal()
//    }
//    semaphone.wait()
//    return result
//  }
//}

