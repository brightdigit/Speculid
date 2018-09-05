import AppKit
import Foundation

guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.brightdigit.Speculid-Mac-App") else {
  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
  print("It doesn't look like Speculid is installed.")
  print("You may want to download the latest version and install it in your Applications folder:")
  print("https://speculid.com")
  
  exit(1)
}

guard let executableURL = Bundle(url: url)?.executableURL else {
  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
  print("It doesn't look like Speculid is installed.")
  print("You may want to download the latest version and install it in your Applications folder:")
  print("https://speculid.com")
  exit(1)
}

let arguments = [String](CommandLine.arguments[1...])
let sourceApplicationName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
let environment = ProcessInfo.processInfo.environment.merging(["sourceApplicationName": sourceApplicationName], uniquingKeysWith: { $1 })
let process = Process()
process.executableURL = executableURL
process.arguments = arguments
process.environment = environment
process.standardOutput = FileHandle.standardOutput
process.standardError = FileHandle.standardError
process.launch()

process.waitUntilExit()
