//
//  ServiceProtocol.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation

@objc
public protocol ServiceProtocol {
  func exportImageAtURL(_ url: URL, toSpecifications specifications: [ImageSpecification], _ callback:  @escaping ((NSError?) -> Void))
}

