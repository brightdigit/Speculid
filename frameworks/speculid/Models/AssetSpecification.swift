//
//  ImageSpecification.swift
//  speculid
//
//  Created by Leo Dion on 9/24/16.
//
//

import Foundation

public struct AssetSpecification : AssetSpecificationProtocol{
  public let idiom : ImageIdiom
  public let scale : CGFloat?
  public let size : CGSize?
  public let filename : String?
}
