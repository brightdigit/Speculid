//
//  Application.swift
//  Speculid_Mac_App
//
//  Created by Leo Dion on 9/19/17.
//

import Cocoa
import Speculid
import CairoSVGBridge

open class Application : Speculid.Application {
  open override func finishLaunching() {
    let interface = NSXPCInterface(with: SpeculidServiceProtocol.self)
    let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")
    connection.remoteObjectInterface = interface
    connection.resume()
    
    if let service = connection.remoteObjectProxy as? SpeculidServiceProtocol{
      
      service.upperCaseString("test", withReply: { (result) in
        print(result)
      })
    }
    super.finishLaunching()
  }
}
