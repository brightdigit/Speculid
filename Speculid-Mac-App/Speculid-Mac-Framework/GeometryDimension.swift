//
//  GeometryDimension.swift
//  Speculid
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa
import CairoSVG

public enum Geometry {
  case width(Int)
  case height(Int)
  
  init (dimension: CairoSVG.Dimension, value: Int) {
    switch (dimension) {
    case .height: self = .height(value)
    case .width: self = .width(value)
    }
  }
}
