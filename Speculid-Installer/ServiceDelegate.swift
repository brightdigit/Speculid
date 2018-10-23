import Cocoa
import CoreFoundation

@objc public protocol InstallerProtocol {
  func hello(name: String) -> String
}

public class Installer : NSObject, InstallerProtocol {
  public func hello(name: String) -> String {
    return ["hello", name].joined(separator:" ")
  }
  
  
}

@objc open class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  public func listener(_: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    let exportedInterface = NSXPCInterface(with: InstallerProtocol.self)
//    let currentClasses: NSSet = exportedInterface.classes(for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false) as NSSet
//    let classes = currentClasses.addingObjects(from: [ImageSpecification.self, ImageFile.self, NSURL.self, NSColor.self])
//    exportedInterface.setClasses(classes, for: #selector(ServiceProtocol.exportImageAtURL(_:toSpecifications:_:)), argumentIndex: 1, ofReply: false)
    newConnection.exportedInterface = exportedInterface
    let exportedObject = Installer()
    newConnection.exportedObject = exportedObject
    newConnection.resume()
    return true
  }
}
