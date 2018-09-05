import AppKit
import Foundation

// first look for bundle that's in parent folder


// next look for bundle that's in /Applications


// next use workspace
guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.brightdigit.Speculid-Mac-App") else {
  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
  exit(1)
}

guard let bundle = Bundle(url: url) else {
  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
  exit(1)
}

guard let buildNumberString = bundle.infoDictionary?[kCFBundleVersionKey as String] as? String else {
  #warning("TODO: Unable to handle version string")
  exit(1)
  
}

guard let buildNumber = Int(buildNumberString) else {
  #warning("TODO: Unable to handle version string")
  exit(1)
}

guard let executableURL = bundle.executableURL else {
  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
  exit(1)
}

let arguments = [String](CommandLine.arguments[1...])
let sourceApplicationName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
let environment = ProcessInfo.processInfo.environment.merging(["sourceApplicationName": sourceApplicationName], uniquingKeysWith: { $1 })
let process = Process()
process.executableURL = executableURL
process.arguments = arguments
process.environment = environment
// ProcessInfo.processInfo.
// ProcessInfo.processInfo.environment + ["" : ""]
process.standardOutput = FileHandle.standardOutput
process.standardError = FileHandle.standardError
process.launch()

process.waitUntilExit()
