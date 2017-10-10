//
//  AppDelegate.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let interface = NSXPCInterface(with: ServiceProtocol.self)
    let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")
    connection.remoteObjectInterface = interface
    connection.resume()
    
    if let service = connection.remoteObjectProxy as? ServiceProtocol{
      service.multiply(4, by: 4, withReply: {
        print($0)
      })
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

