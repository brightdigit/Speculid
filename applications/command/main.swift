import AppKit
import Foundation

enum Result<T> {
  case success(T)
  case error(Error)
}

struct BundleNotFoundError: Error {
  let identifier: String
}

struct TerminationError: Error {
  let status: Int32
  let reason: Process.TerminationReason

  init?(status: Int32, reason: Process.TerminationReason) {
    guard status > 0 else {
      return nil
    }

    self.status = status
    self.reason = reason
  }
}

let speculidMacAppBundleIdentifier = "com.brightdigit.Speculid-Mac-App"

func findApplicationBundle(withIdentifier identifer: String, _ callback: @escaping (Bundle?) -> Void) {
  if let bundle = Bundle(path: "/Applications/Speculid.app"), bundle.bundleIdentifier == speculidMacAppBundleIdentifier {
    callback(bundle)
    return
  }
  guard let urls = LSCopyApplicationURLsForBundleIdentifier(identifer as CFString, nil)?.takeRetainedValue() as? [URL] else {
    callback(nil)
    return
  }
  for url in urls {
    if let bundle = Bundle(url: url) {
      callback(bundle)
      return
    }
  }
  callback(nil)
}

func runApplication(fromBundle bundle: Bundle, withArguments arguments: [String]?, completion: @escaping (Error?) -> Void) {
  guard let executableURL = bundle.executableURL else {
    completion(BundleNotFoundError(identifier: bundle.bundleIdentifier!))
    return
  }
  let arguments = [String](CommandLine.arguments[1...])
  let sourceApplicationName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
  let environment = ProcessInfo.processInfo.environment.merging(["sourceApplicationName": sourceApplicationName], uniquingKeysWith: { $1 })
  let process = Process()
  process.terminationHandler = {
    completion(TerminationError(status: $0.terminationStatus, reason: $0.terminationReason))
  }
  process.executableURL = executableURL
  process.arguments = arguments
  process.environment = environment
  process.standardOutput = FileHandle.standardOutput
  process.standardError = FileHandle.standardError
  process.launch()
}
func runApplication(withBundleIdentifier identifier: String, fromApplicationPathURL applicationPathURL: URL?, withArguments arguments: [String]?, completion: @escaping (Error?) -> Void) {
  if let applicationPathURL = applicationPathURL {
    if let bundle = Bundle(url: applicationPathURL) {
      if bundle.bundleIdentifier == identifier {
        runApplication(fromBundle: bundle, withArguments: arguments, completion: completion)
        return
      }
    }
  }
  findApplicationBundle(withIdentifier: speculidMacAppBundleIdentifier) { bundle in

    guard let bundle = bundle else {
      completion(BundleNotFoundError(identifier: identifier))
      return
    }
    runApplication(fromBundle: bundle, withArguments: nil, completion: completion)
  }
}

DispatchQueue.main.async {
  let arguments: [String]?
  let applicationPathURL: URL?
  if let index = CommandLine.arguments.firstIndex(of: "--useLocation") {
    var tempArguments = CommandLine.arguments
    applicationPathURL = URL(fileURLWithPath: CommandLine.arguments[index + 1])
    tempArguments.removeSubrange(index ... index + 1)
    arguments = tempArguments
  } else {
    applicationPathURL = nil
    arguments = nil
  }

  runApplication(withBundleIdentifier: speculidMacAppBundleIdentifier, fromApplicationPathURL: applicationPathURL, withArguments: arguments, completion: { error in
    if (error as? BundleNotFoundError) != nil {
      #warning("TODO: Handle If Speculid Bundle Isn't Installed")
      print("It doesn't look like Speculid is installed.")
      print("Please download the latest version and install it in your Applications folder:")
      print("https://speculid.com")
      exit(1)
    } else if (error as? TerminationError) != nil {
      exit(1)
    } else {
      exit(0)
    }
  })
}
RunLoop.main.run()
