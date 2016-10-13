//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

var str = "Hello, playground"

PlaygroundPage.current.needsIndefiniteExecution = true
public struct CError : Error {
  public let errno : Int32
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


if let outputURL = try? temporaryURL(), let resourceURL = Bundle.main.url(forResource: "terminal", withExtension: "scpt") {
 
    Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: [resourceURL.path, "echo -n -e \"\\033]0;Finding inkscape..\\007\"; which inkscape > \"\(outputURL.path)\"; exit"])
 
  
  let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
    
    if let string = try? String(contentsOf: outputURL) {
      print("running... \(string)")
      if FileManager.default.fileExists(atPath: string) {
        print(string)
        timer.invalidate()
        
        PlaygroundPage.current.finishExecution()
      }
    }
    
  })
  
  timer.fire()
}

