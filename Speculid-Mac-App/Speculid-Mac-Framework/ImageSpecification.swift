//
//  ImageSpecification.swift
//  Speculid
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa
import CairoSVG

@objc open class ImageSpecification : NSObject,  ImageSpecificationProtocol, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.file, forKey: "file")
    aCoder.encode(self.geometry.dimension.rawValue, forKey: "geometryDimensionValue")
    aCoder.encode(self.geometry.value, forKey: "geometryValue")
    aCoder.encode(self.backgroundColor, forKey: "backgroundColor")
    aCoder.encode(self.removeAlphaChannel, forKey: "removeAlphaChannel")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    
    let _file = aDecoder.decodeObject(forKey: "file") as? ImageFileProtocol
    let _dimensionValue = aDecoder.decodeObject(forKey: "geometryDimensionValue") as? UInt
    let _value = aDecoder.decodeObject(forKey: "geometryValue") as? Int
    let backgroundColor = aDecoder.decodeObject(forKey: "backgroundColor") as? CairoColorProtocol
    let _removeAlphaChannel = aDecoder.decodeObject(forKey: "removeAlphaChannel") as? Bool
    
    guard let file = _file, let dimensionValue = _dimensionValue, let value = _value, let removeAlphaChannel = _removeAlphaChannel, let dimension = CairoSVG.Dimension(rawValue : dimensionValue) else {
      return nil
    }
    
    self.file = file
    self.geometryDimension = Geometry(dimension: dimension, value: value)
    self.backgroundColor = backgroundColor
    self.removeAlphaChannel = removeAlphaChannel
  }
  
  public let file: ImageFileProtocol
  public let geometryDimension: Geometry
  public let removeAlphaChannel: Bool
  public let backgroundColor: CairoColorProtocol?
  public init(file: ImageFileProtocol, geometryDimension: Geometry, removeAlphaChannel: Bool = false, backgroundColor: CairoColorProtocol? = nil) {
    self.file = file
    self.geometryDimension = geometryDimension
    self.removeAlphaChannel = removeAlphaChannel
    self.backgroundColor = backgroundColor
    super.init()
  }
  
  public var geometry: CairoSVG.GeometryDimension {
    switch (self.geometryDimension) {
    case .height(let value): return CairoSVG.GeometryDimension(value: Int32(value), dimension: .height)
    case .width(let value): return CairoSVG.GeometryDimension(value: Int32(value), dimension: .width)
    }
  }
}

