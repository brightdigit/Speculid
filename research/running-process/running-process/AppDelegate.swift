//
//  AppDelegate.swift
//  running-process
//
//  Created by Leo Dion on 10/13/16.
//  Copyright © 2016 BrightDigit. All rights reserved.
//

import Cocoa

func isTerminal(_ app: NSRunningApplication) -> Bool {
  guard let name = app.localizedName else {
    return false
  }
  
  return name.lowercased() == "terminal"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    //NSWorkspace.shared().runn

    if NSWorkspace.shared().runningApplications.index(where: isTerminal) != nil {
      //Process.
      Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: ["-e", "tell application \"Terminal\" to close (every window whose name contains \"inkscape\")"])
      //Process.launchedProcess(launchPath: "/usr/bin/killall", arguments: ["Terminal"])
    }
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

