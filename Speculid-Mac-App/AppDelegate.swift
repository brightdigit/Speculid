//
//  AppDelegate.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/4/17.
//

import Cocoa
import CairoSVGBridge

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    try! ImageHandleBuilder.shared().imageHandle(from: URL(fileURLWithPath: ""))
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

