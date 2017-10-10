//
//  ServiceDelegate.swift
//  xpc-service
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

import Cocoa
import CoreFoundation
import Speculid

open class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    newConnection.exportedInterface = NSXPCInterface(with: ServiceProtocol.self)
    let exportedObject = Service()
    newConnection.exportedObject = exportedObject
    newConnection.resume()
    return true
  }
}
