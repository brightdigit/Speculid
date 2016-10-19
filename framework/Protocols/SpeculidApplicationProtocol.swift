//
//  SpeculidApplicationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/13/16.
//
//

import SwiftVer

public protocol SpeculidApplicationProtocol {
  func document (url: URL) -> SpeculidDocumentProtocol?
  var builder : SpeculidBuilderProtocol { get }
  var version : Version { get }
}
