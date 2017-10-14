//
//  GeometryValue.swift
//  Speculid
//
//  Created by Leo Dion on 10/13/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation

public extension GeometryValue {
  public static func * (left: GeometryValue, right : CGFloat) -> GeometryValue {
    switch left {
    case .height(let value):
      return .height(Int(CGFloat(value) * right))
    case .width(let value):
      return .width(Int(CGFloat(value) * right))
    }
  }
}
