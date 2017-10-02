//
//  Application.swift
//  Speculid_Mac_App
//
//  Created by Leo Dion on 9/19/17.
//

import Cocoa
import Speculid

open class Application: Speculid.Application {
  public func test () {
    let url = Bundle.main.url(forResource: "layers", withExtension: "svg")!
    let destination = URL(fileURLWithPath: "/Users/leo/Documents/Projects/speculid/Speculid_Mac_App/layers.png")
    print(destination)
    let handle = try! ImageHandleBuilder.shared().imageHandle(from: url)
    let dimension = GeometryDimension(value: 900, dimension: .height)
    var error : NSError?
    RSVG.exportImage(handle, to: destination, withDimensions: dimension, shouldRemoveAlphaChannel: false, setBackgroundColor: nil, error: &error)
  }
  open override func finishLaunching() {
    super.finishLaunching()
    self.test()
  }
}
