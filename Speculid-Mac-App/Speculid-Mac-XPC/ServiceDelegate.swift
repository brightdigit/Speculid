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

@objc open class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    let exportedInterface = NSXPCInterface(with: ServiceProtocol.self)
    let classes = (exportedInterface.classes(for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false) as NSSet).addingObjects(from: [ImageSpecification.self, ImageFile.self, NSURL.self, NSColor.self])
    
    //classes.insert([ImageSpecification].self)
    exportedInterface.setClasses(classes, for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false)
    newConnection.exportedInterface = exportedInterface
    let exportedObject = Service()
    newConnection.exportedObject = exportedObject
    newConnection.resume()
    return true
  }
}
