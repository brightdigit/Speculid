//
//  ImageFile.swift
//  Speculid
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa
import CairoSVG

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
