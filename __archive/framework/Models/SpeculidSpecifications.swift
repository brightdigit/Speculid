//
//  SpeculidSpecifications.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

public struct SpeculidSpecifications : SpeculidSpecificationsProtocol {
  public let contentsDirectoryURL : URL
  public let sourceImageURL : URL
  public let geometry: Geometry?
  public let background: NSColor?
  public let removeAlpha: Bool
  
  public init (contentsDirectoryURL : URL,
    sourceImageURL : URL,
    geometry: Geometry? = nil,
    background: NSColor? = nil,
    removeAlpha: Bool = false) {
    self.contentsDirectoryURL = contentsDirectoryURL
    self.geometry = geometry
    self.sourceImageURL = sourceImageURL
    self.background = background
    self.removeAlpha = removeAlpha
  }
 
  public init?(url: URL) {
    let geometry : Geometry?
    let background : NSColor?
    
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
      return nil
    }
    
    guard let dictionary = json as? [String : Any] else {
      return nil
    }
    
    guard let setRelativePath = dictionary["set"] as? String, let sourceRelativePath = dictionary["source"] as? String else {
      return nil
    }
    
    if let backgroundString = dictionary["background"] as? String {
      background = NSColor(backgroundString)
    } else {
      background = nil
    }
    
    if let geometryString = dictionary["geometry"] as? String {
      geometry = Geometry(string: geometryString)
    } else {
      geometry = nil
    }
    
    let contentsJSONURL = url.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
    
    let sourceImageURL = url.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
    
    self.contentsDirectoryURL = contentsJSONURL.deletingLastPathComponent()
    self.sourceImageURL = sourceImageURL
    self.geometry = geometry
    self.background = background
    self.removeAlpha = dictionary["remove-alpha"] as? Bool ?? false
  }
  
}
