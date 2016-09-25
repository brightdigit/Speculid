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
  public let sourceImageUrl : URL
  public let sizePoints : Int?
 
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
    
    
    self.contentsDirectoryUrl = contentsJSONURL.deletingLastPathComponent()
    self.sourceImageUrl = sourceImageUrl
    self.sizePoints = sizePoints
  }
  
}
