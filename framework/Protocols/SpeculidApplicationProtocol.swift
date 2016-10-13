//
//  SpeculidApplicationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/13/16.
//
//

import Foundation
import SwiftVer

public protocol SpeculidApplicationProtocol {
  func begin (withArguments arguments: SpeculidArgumentsProtocol, _ callback: (SpeculidApplicationProtocol) -> Void)
  func document (url: URL) -> SpeculidDocumentProtocol?
  var builder : SpeculidBuilderProtocol { get }
  var version : Version { get }
}
