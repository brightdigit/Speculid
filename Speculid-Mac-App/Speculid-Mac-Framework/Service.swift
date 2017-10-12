//
//  Service.swift
//  xpc-service
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

import Cocoa
import CairoSVG

public class ErrorCollection : NSError {
  public let errors : [NSError]
  
  public init?(errors : [NSError]) {
    guard errors.count > 0 else {
      return nil
    }
    self.errors = errors
    super.init(domain: Bundle(for: type(of: self)).bundleIdentifier!, code: 800, userInfo: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    guard let errors = aDecoder.decodeObject(forKey: "errors") as? [NSError] else {
      return nil
    }
    self.errors = errors
    super.init(coder: aDecoder)
  }
  
  public override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(self.errors, forKey: "errors")
  }
}

public enum FileFormat : UInt {
  case png
  case svg
  case pdf
}

extension FileFormat {
  var imageFileFormat : ImageFileFormat {
    switch (self) {
    case .pdf: return ImageFileFormat.pdf
    case .png: return ImageFileFormat.png
    case .svg: return ImageFileFormat.svg
    }
  }
  
  
}
public class ImageFile : NSObject, ImageFileProtocol, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.url, forKey: "url")
    aCoder.encode(self.fileFormat.imageFileFormat.rawValue, forKey: "fileFormatValue")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    
    let _url = aDecoder.decodeObject(forKey: "url") as? URL
    let _fileFormatValue = aDecoder.decodeObject(forKey: "fileFormatValue") as? UInt
    
    
    guard let url = _url, let fileFormatValue = _fileFormatValue, let fileFormat = FileFormat(rawValue: fileFormatValue) else {
      return nil
    }
    
    self.url = url
    self.fileFormat = fileFormat
  }
  
  public let url: URL
  public let fileFormat: FileFormat
  public init(url: URL, fileFormat: FileFormat) {
    self.url = url
    self.fileFormat = fileFormat
    super.init()
  }
  
  public var format: ImageFileFormat {
    return self.fileFormat.imageFileFormat
  }
}

public enum GeometryDimension {
  case width(Double)
  case height(Double)
  
  init (dimension: CairoSVG.Dimension, value: Double) {
    switch (dimension) {
    case .height: self = .height(value)
    case .width: self = .width(value)
    }
  }
}


@objc(ImageSpecification) open class ImageSpecification : NSObject,  ImageSpecificationProtocol, NSSecureCoding {
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
    let _value = aDecoder.decodeObject(forKey: "geometryValue") as? Double
    let backgroundColor = aDecoder.decodeObject(forKey: "backgroundColor") as? CairoColorProtocol
    let _removeAlphaChannel = aDecoder.decodeObject(forKey: "removeAlphaChannel") as? Bool
    
    guard let file = _file, let dimensionValue = _dimensionValue, let value = _value, let removeAlphaChannel = _removeAlphaChannel, let dimension = CairoSVG.Dimension(rawValue : dimensionValue) else {
      return nil
    }
    
    self.file = file
    self.geometryDimension = Speculid.GeometryDimension(dimension: dimension, value: value)
    self.backgroundColor = backgroundColor
    self.removeAlphaChannel = removeAlphaChannel
  }
  
  public let file: ImageFileProtocol
  public let geometryDimension: Speculid.GeometryDimension
  public let removeAlphaChannel: Bool
  public let backgroundColor: CairoColorProtocol?
  public init(file: ImageFileProtocol, geometryDimension: Speculid.GeometryDimension, removeAlphaChannel: Bool = false, backgroundColor: CairoColorProtocol? = nil) {
    self.file = file
    self.geometryDimension = geometryDimension
    self.removeAlphaChannel = removeAlphaChannel
    self.backgroundColor = backgroundColor
    super.init()
  }
  
  public var geometry: CairoSVG.GeometryDimension {
    switch (self.geometryDimension) {
    case .height(let value): return CairoSVG.GeometryDimension(value: value, dimension: .height)
      case .width(let value): return CairoSVG.GeometryDimension(value: value, dimension: .width)
    }
  }
}

extension NSColor : CairoColorProtocol {
  public var red: Double {
    return Double(self.redComponent)
  }
  
  public var green: Double {
    return Double(self.greenComponent)
  }
  
  public var blue: Double {
    return Double(self.blueComponent)
  }
  
  
}

public final class Service: NSObject, ServiceProtocol {
  public func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback: @escaping ((NSError?) -> Void)) {
    
    
    let imageFile = ImageFile(url: url, fileFormat: .svg)
    let builtImageHandle : ImageHandle?
    do {
      builtImageHandle = try ImageHandleBuilder.shared().imageHandle(fromFile: imageFile)
    } catch let error as NSError {
      callback(error)
      return
    }
    
    guard let imageHandle = builtImageHandle else {
      return
    }
    
    
    
    let group = DispatchGroup()
    var errors = [NSError]()
    
    for specs in specifications {
      DispatchQueue.main.async {
        group.enter()
        do {
        try CairoInterface.exportImage(imageHandle, withSpecification: specs)
        } catch let error as NSError {
          errors.append(error)
        }
        group.leave()
      }
    }
    
    group.notify(queue: .main) {
      callback(ErrorCollection(errors: errors))
    }
  }
  
  
//  public func multiply(_ value: Double, by factor: Double, withReply reply: (Double) -> Void) {
//    if let url = Bundle(for: Service.self).url(forResource: "layers", withExtension: "svg") {
//
//      let imageFile = ImageFile(url: url, format: .svg)
//      let destinationImage = ImageFile(url: Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("layers.png"), fileFormat: .png)
//      let exportSpecifications = ImageSpecification(file: destinationImage, geometry: GeometryDimension(value: 100, dimension: .width), removeAlphaChannel: true, backgroundColor: NSColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
//      if let imageHandle = try? ImageHandleBuilder.shared().imageHandle(fromFile: imageFile) {
//        try? CairoInterface.exportImage(imageHandle, withSpecification: exportSpecifications)
//
//
//    }
//    }
//    reply(value * factor)
//  }
  
  
}
