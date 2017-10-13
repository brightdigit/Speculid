//
//  Application.swift
//  Speculid
//
//  Created by Leo Dion on 9/19/17.
//

import Foundation
import AppKit

open class Application : NSApplication {
  var statusItem: NSStatusItem!
  
  open override func finishLaunching() {
    super.finishLaunching()
    
    let menu = NSMenu(title: "Speculid")
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    item.title = "Speculid"
    item.menu = menu
    self.statusItem = item
  }
}
