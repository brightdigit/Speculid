//
//  NSColor.swift
//  Speculid
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation
import CairoSVG

extension NSColor : CairoColorProtocol {
  public var red: Double {
    return Double(self.redComponent)
  }
  
  public var green: Double {
    return Double(self.greenComponent)
  }
  
  public var blue: Double {
    return Double(self.blueComponent)
  }
}
