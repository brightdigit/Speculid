//
//  ResizeOption.swift
//  Speculid
//
//  Created by Leo Dion on 7/17/20.
//

import Foundation
import SpeculidKit

struct ResizeOption : LabeledOption {
  static let all = Self.allValues()
  
  let rawValue: Int
  
  static let mappedValues: [ String] =
    [ "None", "Width", "Height"]
  
  let label: String
  
  static let none = all[0]
  static let width = all[1]
  static let height = all[2]
}

extension ResizeOption {
  init(geometryType: GeometryType?) {
    switch (geometryType){
    case .some(.width):
      self = .width
    case .some(.height):
      self = .height
    default:
      self = .none
    }
  }
}
