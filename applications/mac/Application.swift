//
//  Application.swift
//  Speculid_Mac_App
//
//  Created by Leo Dion on 9/19/17.
//

import Cocoa
import Speculid

open class Application : Speculid.Application {
  open override func finishLaunching() {
    
    let interface = NSXPCInterface(with: ServiceProtocol.self)
    let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")
    connection.remoteObjectInterface = interface
    connection.resume()
    if let url = Bundle.main.url(forResource: "layers", withExtension: "svg"), let service = connection.remoteObjectProxy as? ServiceProtocol{
      let exportSpecifications = [32,64,128,256].map { (width) -> ImageSpecification in
        let file = ImageFile(url: Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("layers.\(width).png"), fileFormat: FileFormat.png)
        return ImageSpecification(file: file, geometryDimension: .width(width), removeAlphaChannel: true, backgroundColor: NSColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
      }
      service.exportImageAtURL(url, toSpecifications:exportSpecifications, { (error) in
        debugPrint(error)
        
      })
    }
    super.finishLaunching()
  }
}
