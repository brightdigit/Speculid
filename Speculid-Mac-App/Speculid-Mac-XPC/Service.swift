//
//  Service.swift
//  xpc-service
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

import Cocoa

public final class Service: NSObject, ServiceProtocol {
  public func multiply(_ value: Double, by factor: Double, withReply reply: (Double) -> Void) {
    reply(value * factor)
  }
  
  
}
