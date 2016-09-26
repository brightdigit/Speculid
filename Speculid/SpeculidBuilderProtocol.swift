//
//  SpeculidBuilderProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public protocol SpeculidBuilderProtocol {
  func build (document: SpeculidDocument, callback: ((Error?) -> Void))
}
