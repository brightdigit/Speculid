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
  func multiply(_ value: Double, by factor: Double, withReply reply: (Double) -> Void)
}

