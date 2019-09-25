//
//  AssetCatalogDocument.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 9/25/19.
//  Copyright © 2019 Bright Digit, LLC. All rights reserved.
//
import Foundation

public class AssetCatalogItem: NSObject, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(filename, forKey: "filename")
    aCoder.encode(scale, forKey: "scale")
    aCoder.encode(size, forKey: "size")
    aCoder.encode(idiom, forKey: "idiom")
  }

  // swiftlint:disable identifier_name
  public required init?(coder aDecoder: NSCoder) {
    guard let filename = aDecoder.decodeObject(forKey: "filename") as? String else {
      return nil
    }
    guard let idiom = aDecoder.decodeObject(forKey: "idiom") as? String else {
      return nil
    }
    size = aDecoder.decodeObject(forKey: "size").flatMap { $0 as? CGSize }
    scale = aDecoder.decodeObject(forKey: "scale").flatMap { $0 as? CGFloat }
    self.filename = filename
    self.idiom = idiom
  }

  public let idiom: String
  public let scale: CGFloat?
  public let size: CGSize?
  public let filename: String

  init(specs: AssetSpecificationProtocol, filename: String) {
    idiom = specs.idiom.rawValue
    scale = specs.scale
    size = specs.size
    self.filename = filename
  }
}
