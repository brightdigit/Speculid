//
//  CGFloat.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation

extension CGFloat {
  var cleanValue: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(describing: self)
  }
}
