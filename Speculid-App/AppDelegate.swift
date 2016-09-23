//
//  AppDelegate.swift
//  Speculid-App
//
//  Created by Leo Dion on 9/22/16.
//
//

import Cocoa
import PocketSVG

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
                      //inkscape --export-id=Release --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg
                      //for x in 29 40 58 76 87 80 120 152 167 180 ; do inkscape --without-gui --export-png tictalktoc-app/tictalktoc/Images.xcassets/AppIcon-lite.appiconset/lite${x}.png -w ${x} graphics/icons/logo.svg >/dev/null && echo "exporting appicon_${x}.png" & done
                      let destinationURL = contentsJSONURL.deletingLastPathComponent().appendingPathComponent(sourcePath.deletingPathExtension().lastPathComponent).appendingPathExtension(".png")
                      let process = Process()
                      process.launchPath = "/usr/local/bin/inkscape"
                      process.arguments = ["--without-gui","--export-png",destinationURL.path,"-w","${x}",sourcePath.absoluteString]
                      process.launch()
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

