//
//  AssetCatalogDocument.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 9/25/19.
//  Copyright © 2019 Bright Digit, LLC. All rights reserved.
//
import Foundation

extension NSNumber {
  // CGFloat -> NSNumber
  private convenience init(doubleOrFloat: Double) {
    self.init(value: doubleOrFloat)
  }
  private convenience init(doubleOrFloat: Float) {
    self.init(value: doubleOrFloat)
  }
  convenience init(cgFloat: CGFloat) {
    self.init(doubleOrFloat: cgFloat.native)
  }

  // NSNumber -> CGFloat
  private func doubleOrFloatValue() -> Double {
    return doubleValue
  }
  private func doubleOrFloatValue() -> Float {
    return floatValue
  }
  var cgFloatValue: CGFloat {
    return CGFloat(floatLiteral: doubleOrFloatValue())
  }
}

@objc open class AssetCatalogItemSize: NSObject, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true

  public func encode(with coder: NSCoder) {
    coder.encode(width, forKey: "width")
    coder.encode(height, forKey: "height")
  }

  public required init?(coder: NSCoder) {
    guard let width = coder.decodeObject(forKey: "width") as? NSNumber else {
      return nil
    }

    guard let height = coder.decodeObject(forKey: "height") as? NSNumber else {
      return nil
    }

    self.width = width
    self.height = height
  }

  public let width: NSNumber
  public let height: NSNumber

  public init(size: CGSize) {
    width = size.width as NSNumber
    height = size.height as NSNumber
  }
}

extension AssetCatalogItemSize {
  var cgSize: CGSize {
    return CGSize(width: width.cgFloatValue, height: height.cgFloatValue)
  }
}
@objc open class AssetCatalogItem: NSObject, NSSecureCoding {
  public static let supportsSecureCoding: Bool = true

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(filename, forKey: "filename")
    aCoder.encode(scale, forKey: "scale")
    aCoder.encode(size, forKey: "size")
    aCoder.encode(idiom, forKey: "idiom")
    aCoder.encode(subtype, forKey: "subtype")
    aCoder.encode(role, forKey: "role")
  }

  // swiftlint:disable identifier_name
  public required init?(coder aDecoder: NSCoder) {
    guard let filename = aDecoder.decodeObject(forKey: "filename") as? String else {
      return nil
    }
    guard let idiom = aDecoder.decodeObject(forKey: "idiom") as? String else {
      return nil
    }
    size = aDecoder.decodeObject(forKey: "size").flatMap { $0 as? AssetCatalogItemSize }
    scale = aDecoder.decodeObject(forKey: "scale").flatMap { $0 as? NSNumber }
    subtype = aDecoder.decodeObject(forKey: "subtype").flatMap { $0 as? String }
    role = aDecoder.decodeObject(forKey: "role").flatMap { $0 as? String }
    self.filename = filename
    self.idiom = idiom
  }

  public let idiom: String
  public let scale: NSNumber?
  public let size: AssetCatalogItemSize?
  public let filename: String
  public let subtype: String?
  public let role: String?

  init(specs: AssetSpecificationProtocol, filename: String) {
    idiom = specs.idiom.rawValue
    subtype = specs.subtype?.rawValue
    role = specs.role?.rawValue
    scale = specs.scale.map(NSNumber.init)
    size = specs.size.map(AssetCatalogItemSize.init)
    self.filename = filename
  }
}
