//
//  AppDelegate.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa
import Speculid

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
      guard let url = Bundle.main.url(forResource: "layers", withExtension: "svg") else {
        return
      }
      let exportSpecifications = [32,64,128,256].map { (width) -> ImageSpecification in
        let file = ImageFile(url: Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("layers.\(width).png"), fileFormat: FileFormat.png)
        return ImageSpecification(file: file, geometryDimension: .width(Double(width)), removeAlphaChannel: true, backgroundColor: NSColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
      }
//      service.multiply(4, by: 4, withReply: {
//        print($0)
//      })
      service.exportImageAtURL(url, toSpecifications:exportSpecifications, { (error) in
        debugPrint(error)
      })
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

