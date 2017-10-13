//
//  main.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation
import Speculid
import AppKit

let runLoop = CFRunLoopGetCurrent()
let interface = NSXPCInterface(with: ServiceProtocol.self)
let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")
connection.remoteObjectInterface = interface
connection.resume()


if let service = connection.remoteObjectProxy as? ServiceProtocol{
  guard let url = Bundle.main.url(forResource: "layers", withExtension: "svg") else {
    exit(1)
  }
  let exportSpecifications = [32,64,128,256].map { (width) -> ImageSpecification in
    let file = ImageFile(url: Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("layers.\(width).png"), fileFormat: FileFormat.png)
    return ImageSpecification(file: file, geometryDimension: .width(width), removeAlphaChannel: true, backgroundColor: NSColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
  }
  //      service.multiply(4, by: 4, withReply: {
  //        print($0)
  //      })
  service.exportImageAtURL(url, toSpecifications:exportSpecifications, { (error) in
    debugPrint(error)
    CFRunLoopStop(runLoop)
    
  })
}
CFRunLoopRun()

