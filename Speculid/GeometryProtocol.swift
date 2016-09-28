//
//  GeometryProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/28/16.
//
//

import Foundation

public protocol GeometryProtocol : CustomStringConvertible {
  func text (scaledBy scale: Int) -> String
}

extension GeometryProtocol {
  public func scaling (by scale: Int) -> GeometryProtocol {
    return ScaledGeometry(self, byScale: scale)
  }
}
