//
//  SpeculidSpecifications.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct SpeculidSpecifications {
  public let contentsDirectoryUrl : URL
  public let imageContentsUrl : URL
  public let sourceImageUrl : URL
  public let sizePoints : Int?
  public let images : [ImageSpecification]
 
  public init?(url: URL) {
    let sizePoints : Int?
    
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
      return nil
    }
    
    guard let dictionary = json as? [String : String] else {
      return nil
    }
    
    guard let setRelativePath = dictionary["set"], let sourceRelativePath = dictionary["source"] else {
      return nil
    }
    
    if let sizePointsString = dictionary["size"] {
      sizePoints = Int(sizePointsString)
    } else {
      sizePoints = nil
    }
    
    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
    
    let sourceImageUrl = url.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
    guard let contentsJSONData = try? Data(contentsOf: contentsJSONURL) else {
      return nil
    }
    
    guard let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String : Any] else {
      return nil
    }
    
    guard let images = contentsJSON?["images"] as? [[String : String]]  else {
      return nil
    }
    
    self.images = images.flatMap { (dictionary) -> ImageSpecification? in
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

    self.imageContentsUrl = contentsJSONURL
    self.contentsDirectoryUrl = contentsJSONURL.deletingLastPathComponent()
    self.sourceImageUrl = sourceImageUrl
    self.sizePoints = sizePoints
  }
  
}
