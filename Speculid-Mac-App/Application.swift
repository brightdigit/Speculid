//
//  Application.swift
//  Speculid_Mac_App
//
//  Created by Leo Dion on 9/19/17.
//

import Cocoa
import Speculid
import CairoSVGBridge

open class Application: Speculid.Application {
  public func test () {
    
  }
  open override func finishLaunching() {
    super.finishLaunching()
    self.test()
  }
}
