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
// NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
// [query setSearchScopes: @[@"/Applications"]];  // if you want to isolate to Applications
// NSPredicate *pred = [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];
//
//// Register for NSMetadataQueryDidFinishGatheringNotification here because you need that to
//// know when the query has completed
//
// [query setPredicate:pred];
// [query startQuery];

func findApplicationBundle(withIdentifier identifer: String, _ callback: @escaping (Bundle?) -> Void) {
  let query = NSMetadataQuery()
  let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil, queue: nil) { _ in
    // NotificationCenter.default.removeObserver(observer)
    for result in query.results {
      if let item = result as? NSMetadataItem {
        if let path = item.value(forAttribute: NSMetadataItemPathKey) as? String {
          if let bundle = Bundle(url: URL(fileURLWithPath: path)) {
            if bundle.bundleIdentifier == identifer {
              callback(bundle)
              return
            }
          }
        }
      }
    }
    callback(nil)
  }
  let predicate = NSPredicate(format: "kMDItemKind == 'Application'")
  query.valueListAttributes = [NSMetadataItemURLKey]
  query.predicate = predicate
  query.start()
}

//
// guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: speculidMacAppBundleIdentifier) else {
//  #warning("TODO: Handle If Speculid Bundle Isn't Installed")
//  print("It doesn't look like Speculid is installed.")
//  print("You may want to download the latest version and install it in your Applications folder:")
//  print("https://speculid.com")
//
//  exit(1)
// }

func runApplication(withBundleIdentifier identifier: String, completion: @escaping (Error?) -> Void) {
  findApplicationBundle(withIdentifier: speculidMacAppBundleIdentifier) { bundle in

    guard let executableURL = bundle?.executableURL else {
      completion(BundleNotFoundError(identifier: identifier))
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
}

DispatchQueue.main.async {
  runApplication(withBundleIdentifier: speculidMacAppBundleIdentifier, completion: { error in
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
