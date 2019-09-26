import Cocoa
import CoreFoundation

public enum InstallerErrorCode: Int {
  public typealias RawValue = Int
  case bundleNotFound = 1
  case sharedSupportNotFound = 2
  case speculidCommandNotFound = 3
  case usrLocalBinDirNotFound = 4
}

public struct InstallerError {
  private init() {}
  static func error(fromCode code: InstallerErrorCode) -> NSError {
    return NSError(domain: Bundle.main.bundleIdentifier!, code: code.rawValue, userInfo: nil)
  }
}

public class Installer: NSObject, InstallerProtocol {
  public func installCommandLineTool(fromBundleURL bundleURL: URL, _ completed: @escaping (NSError?) -> Void) {
    guard let bundle = Bundle(url: bundleURL) else {
      return completed(InstallerError.error(fromCode: .bundleNotFound))
    }

    guard let speculidCommandURL = bundle.sharedSupportURL?.appendingPathComponent("speculid") else {
      return completed(InstallerError.error(fromCode: .sharedSupportNotFound))
    }

    guard FileManager.default.fileExists(atPath: speculidCommandURL.path) else {
      return completed(InstallerError.error(fromCode: .speculidCommandNotFound))
    }

    let binDirectoryURL = URL(fileURLWithPath: "/usr/local/bin", isDirectory: true)

    var isDirectory: ObjCBool = false

    let binDirExists = FileManager.default.fileExists(atPath: binDirectoryURL.path, isDirectory: &isDirectory)

    guard isDirectory.boolValue, binDirExists else {
      return completed(InstallerError.error(fromCode: .usrLocalBinDirNotFound))
    }

    let destURL = binDirectoryURL.appendingPathComponent(speculidCommandURL.lastPathComponent)

    do {
      if FileManager.default.fileExists(atPath: destURL.path) {
        try FileManager.default.removeItem(at: destURL)
      }
      try FileManager.default.copyItem(at: speculidCommandURL, to: destURL)
    } catch let error as NSError {
      completed(error)
    }

    completed(nil)
  }

  public func hello(name: String, _ completed: @escaping (String) -> Void) {
    completed(["hello", name].joined(separator: " "))
  }
}

@objc open class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  private var connections = [NSXPCConnection]()
  public private(set) var shouldQuit = false
  public private(set) var shouldQuitCheckInterval = 1.0
  public func listener(_: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    let exportedInterface = NSXPCInterface(with: InstallerProtocol.self)
//    let currentClasses: NSSet = exportedInterface.classes(for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false) as NSSet
//    let classes = currentClasses.addingObjects(from: [ImageSpecification.self, ImageFile.self, NSURL.self, NSColor.self])
//    exportedInterface.setClasses(classes, for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false)
    newConnection.exportedInterface = exportedInterface
    let exportedObject = Installer()
    newConnection.exportedObject = exportedObject
    newConnection.invalidationHandler = {
      if let connectionIndex = self.connections.firstIndex(of: newConnection) {
        self.connections.remove(at: connectionIndex)
      }

      if self.connections.isEmpty {
        self.shouldQuit = true
      }
    }
    connections.append(newConnection)
    newConnection.resume()
    return true
  }
}
