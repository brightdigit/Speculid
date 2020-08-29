//
//  LabeledOption.swift
//  Speculid
//
//  Created by Leo Dion on 7/17/20.
//

import Foundation

protocol LabeledOption : RawRepresentable, Equatable, Identifiable where RawValue == Int{
  static var mappedValues : [String] { get }
  var label: String { get }
  init (rawValue: RawValue, label : String)
}

extension LabeledOption {
  var id: Int {
    return self.rawValue
  }
  
  static func allValues () -> [Self] {
    self.mappedValues.enumerated().compactMap {
      Self.init(rawValue: $0.offset, label: $0.element)
    }
  }
  
  init?(rawValue: RawValue) {
    self.init(rawValue: rawValue, label: Self.mappedValues[rawValue])
  }
}
