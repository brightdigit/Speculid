//
//  SpeculidSpecificationsProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Cocoa

public protocol SpeculidSpecificationsProtocol {
  var contentsDirectoryURL : URL { get }
  var sourceImageURL : URL { get }
  var geometry : Geometry? { get }
}
