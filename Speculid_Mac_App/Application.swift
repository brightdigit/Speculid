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
    let url = Bundle.main.url(forResource: "layers", withExtension: "svg")
    let handle = try! ImageHandleBuilder.shared().imageHandle(from: url)
    
  }
}
