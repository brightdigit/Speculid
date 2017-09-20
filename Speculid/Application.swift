//
//  Application.swift
//  Speculid
//
//  Created by Leo Dion on 9/19/17.
//

import Foundation

open class Application : NSApplication {
  var statusItem: NSStatusItem!
  
  open override func finishLaunching() {
    super.finishLaunching()
    
    let menu = NSMenu(title: "Speculid")
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    item.image = #imageLiteral(resourceName: "TrayIcon")
    item.menu = menu
    self.statusItem = item
  }
}
