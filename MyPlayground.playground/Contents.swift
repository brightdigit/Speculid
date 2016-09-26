import Foundation

print(ProcessInfo.processInfo.environment)

let process = Process()
//process.environment = ["PATH":"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"]
process.launchPath = "/usr/bin/env"



let pipe = Pipe()

process.standardOutput = pipe
let fileHandle = pipe.fileHandleForReading
//let outHandle = pipe.fileHandleForReading
//outHandle.waitForDataInBackgroundAndNotify()

process.launch()

let data = fileHandle.readDataToEndOfFile()
process.waitUntilExit()
let text = String(data: data, encoding: .utf8)
text?.components(separatedBy: "\n").reduce([:], { (environment, line) -> [String:String] in
  var newDictionary = environment
  //let pair = line.components(separatedBy: "=")
  //newDictionary[pair[0]] = pair[1]
  return newDictionary
})