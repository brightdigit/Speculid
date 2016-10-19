//
//  SearchApplicationPathDataSource.swift
//  speculid
//
//  Created by Leo Dion on 10/19/16.
//
//

import Foundation

extension CFRunLoopTimer {
  /**
   Creates and schedules a one-time `NSTimer` instance.
   
   - Parameters:
   - delay: The delay before execution.
   - handler: A closure to execute after `delay`.
   
   - Returns: The newly-created `NSTimer` instance.
   */
  class func schedule(delay: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> CFRunLoopTimer? {
    let fireDate = delay + CFAbsoluteTimeGetCurrent()
    
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
    
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    return timer
  }
  
  /**
   Creates and schedules a repeating `NSTimer` instance.
   
   - Parameters:
   - repeatInterval: The interval (in seconds) between each execution of
   `handler`. Note that individual calls may be delayed; subsequent calls
   to `handler` will be based on the time the timer was created.
   - handler: A closure to execute at each `repeatInterval`.
   
   - Returns: The newly-created `NSTimer` instance.
   */
  class func schedule(repeatInterval interval: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> CFRunLoopTimer? {
    let fireDate = interval + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    return timer
  }
}
public struct SearchApplicationPathDataSource : ApplicationPathDataSource {
  
  
  public struct CError : Error {
    public let errno : Int32
  }
  
  typealias WhichParameter = (command: String, output: URL)
  
  func isTerminal(_ app: NSRunningApplication) -> Bool {
    guard let name = app.localizedName else {
      return false
    }
    
    return name.lowercased() == "terminal"
  }
  
  func temporaryURL () throws -> URL {
    
    let template = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("file.XXXXXX") as NSURL
    
    // Fill buffer with a C string representing the local file system path.
    var buffer = [Int8](repeating: 0, count: Int(PATH_MAX))
    template.getFileSystemRepresentation(&buffer, maxLength: buffer.count)
    
    // Create unique file name (and open file):
    let fd = mkstemp(&buffer)
    if fd != -1 {
      
      // Create URL from file system string:
      return URL(fileURLWithFileSystemRepresentation: buffer, isDirectory: false, relativeTo: nil)
      
      
    } else {
      //print("Error: " + String(cString: strerror(errno)))
      throw CError(errno: errno)
    }
  }
  
  func which (_ commands : [String], closure: @escaping (([String : URL]) -> Void)) {
    let terminalLaunched = NSWorkspace.shared().runningApplications.index(where: isTerminal) == nil
    
    
    guard let resourceURL = Speculid.bundle.url(forResource: "terminal", withExtension: "scpt") else {
      
      closure([String : URL]())
      return
    }
    
    let whichParameters : [WhichParameter] = commands.flatMap{
      guard let url = try? temporaryURL() else {
        return nil
      }
      
      return WhichParameter(command: $0, output: url)
    }
    
    guard whichParameters.count > 0 else {
      closure([String : URL]())
      return
    }
    
    var arguments = ["echo -n -e \"\\033]0;Speculid - Dependency Search\\007\""]
    arguments.append(contentsOf: whichParameters.map{ "which \($0.command) > \"\($0.output.path)\"" })
    arguments.append("exit")
    
    var locations = [String : URL]()
    
    Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: [resourceURL.path, arguments.joined(separator: "; ")])
    
    CFRunLoopTimer.schedule(repeatInterval: 1.0) { (timer) in
      for pair in whichParameters {
        if locations[pair.command] == nil {
          if let string = (try? String(contentsOf: pair.output))?.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
            ) {
            if FileManager.default.fileExists(atPath: string) {
              print(string)
              locations[pair.command] = URL(fileURLWithPath: string)
            }
          }
        }
      }
      
      if locations.count >= whichParameters.count {
        Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: ["-e", "tell application \"Terminal\" to close (every window whose name contains \"Speculid\")", "&"])
        if terminalLaunched {
          Process.launchedProcess(launchPath: "/usr/bin/killall", arguments: ["Terminal"])
        }
        CFRunLoopTimerInvalidate(timer)
        closure(locations)
      }
    }
    
    
  }
  
  public func applicationPaths(_ closure: @escaping (ApplicationPathDictionary) -> Void) {
    which(["inkscape", "convert"]) { (lookup) in
      let result = lookup.reduce(ApplicationPathDictionary(), { (dictionary, pair) -> ApplicationPathDictionary in
        var result = dictionary
        result[ApplicationPath(rawValue: pair.key)!] = pair.value
        return result
      })
      closure(result)
    }
  }

}
