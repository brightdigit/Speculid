//
//  SpeculidSpecifications.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct SpeculidSpecifications : SpeculidSpecificationsProtocol {
  public let contentsDirectoryURL : URL
  public let sourceImageURL : URL
  public let geometry: Geometry?
 
  public init?(url: URL, maxScale: CGFloat? = nil) {
    let geometry : Geometry?
    
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
    
    if let geometryString = dictionary["geometry"] {
      geometry = Geometry(string: geometryString)
    } else {
      geometry = nil
    }
    
    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
    
    let sourceImageURL = url.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
    
    self.contentsDirectoryURL = contentsJSONURL.deletingLastPathComponent()
    self.sourceImageURL = sourceImageURL
    self.geometry = geometry
  }
  
}
