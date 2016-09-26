//
//  ImageSpecification.swift
//  speculid
//
//  Created by Leo Dion on 9/24/16.
//
//

import Foundation

public enum ImageIdiom : String {
  case universal = "universal",
  iphone = "iphone",
  ipad = "ipad",
  mac = "mac",
  tv = "tv",
  watch = "watch"
}

public struct ImageSpecification {
  public let idiom : ImageIdiom
  public let scale : CGFloat?
  public let size : CGSize?
  public let filename : String?
  
}
