//
//  AppDelegate.swift
//  Speculid-App
//
//  Created by Leo Dion on 9/22/16.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    #if DEBUG
    print("DEBUG")
    let speculidURL = Bundle.main.url(forResource: "speculid", withExtension: "spcld")
      
      
    #endif
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

