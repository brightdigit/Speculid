//
//  GeometryProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

import Foundation

public enum GeometryValue {
  case Width(Int), Height(Int)
}

public protocol GeometryProtocol : CustomStringConvertible {
  func text (scaledBy scale: Int) -> String
}

extension GeometryProtocol {
  public func scaling (by scale: Int) -> GeometryProtocol {
    return ScaledGeometry(self, byScale: scale)
  }
}
