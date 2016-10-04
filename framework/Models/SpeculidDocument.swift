//
//  SpeculidDocument.swift
//  speculid
//
//  Created by Leo Dion on 9/24/16.
//
//

import Foundation

let scaleRegex = try! NSRegularExpression(pattern: "(\\d+)x", options: [])
let sizeRegex = try! NSRegularExpression(pattern: "(\\d+\\.?\\d*)x(\\d+\\.?\\d*)", options: [])
let numberRegex = try! NSRegularExpression(pattern: "\\d", options: [])

public struct SpeculidDocument : SpeculidDocumentProtocol {
  public let _specifications : SpeculidSpecifications
  public let _images : [ImageSpecification]
  
  public var specifications: SpeculidSpecificationsProtocol {
    return self._specifications
  }
  
  public var images: [ImageSpecificationProtocol] {
    return self._images
  }
  
  public init?(url: URL, configuration: SpeculidConfiguration? = nil) {
    
    guard let specifications = SpeculidSpecifications(url: url) else {
      return nil
    }
    
    guard let contentsJSONData = try? Data(contentsOf: specifications.contentsDirectoryURL.appendingPathComponent("Contents.json")) else {
      return nil
    }
    
    guard let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String : Any] else {
      return nil
    }
    
    guard let images = contentsJSON?["images"] as? [[String : String]]  else {
      return nil
    }
    
    self._images = images.flatMap { (dictionary) -> ImageSpecification? in
      let scale: CGFloat?
      let size: CGSize?
      
      if let scaleString = dictionary["scale"]?.firstMatchGroups(regex: scaleRegex)?[1], let value = Double(scaleString) {
        scale = CGFloat(value)
      } else {
        scale = nil
      }
      
      guard let idiomString = dictionary["idiom"], let idiom = ImageIdiom(rawValue: idiomString) else {
        return nil
      }
      
      if let dimensionStrings = dictionary["size"]?.firstMatchGroups(regex: sizeRegex), let width = Double(dimensionStrings[1]), let height = Double(dimensionStrings[2]) {
        size = CGSize(width: width, height: height)
      } else {
        size = nil
      }
      
      let filename = dictionary["filename"]
      
      return ImageSpecification(idiom: idiom, scale: scale, size: size, filename: filename)
    }
    
    
    
    self._specifications = specifications
  }
}
