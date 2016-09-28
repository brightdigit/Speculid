//
//  SpeculidDocumentProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Cocoa

public protocol SpeculidDocumentProtocol {
  var specifications : SpeculidSpecificationsProtocol { get }
  var images : [ImageSpecificationProtocol] { get }
  
}
