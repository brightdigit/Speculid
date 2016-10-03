//
//  ScaledGeometry.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

import Foundation

public struct ScaledGeometry : GeometryProtocol {
  public func text(scaledBy scale: Int) -> String {
    return self.base.scaling(by: scale * self.scale).description
  }
  
  public let base: GeometryProtocol
  public let scale: Int
  
  public init (_ base: GeometryProtocol, byScale scale: Int) {
    self.base = base
    self.scale = scale
  }
  
  public var description: String {
    return self.base.text(scaledBy: self.scale)
  }
}
