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
      if let speculidURL = Bundle.main.url(forResource: "speculid", withExtension: "spcld") {
        if let data = try? Data(contentsOf: speculidURL) {
          if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dictionary = json as? [String : String] {
              if let setRelativePath = dictionary["set"], let sourceRelativePath = dictionary["source"] {
                
                let contentsJSONURL = speculidURL.deletingLastPathComponent().appendingPathComponent(setRelativePath, isDirectory: true).appendingPathComponent("Contents.json")
                let sourcePath = speculidURL.deletingLastPathComponent().appendingPathComponent(sourceRelativePath)
                
                if let contentsJSONData = try? Data(contentsOf: contentsJSONURL) {
                  if let contentsJSON = try? JSONSerialization.jsonObject(with: contentsJSONData, options: []) as? [String : Any] {
                    if let images = contentsJSON?["images"] as? [[String : String]] {
                      print(images)
                    }
                  }
                }
              }
            }
          }
        }
      }
      
      
    #endif
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

