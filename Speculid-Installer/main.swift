import Foundation

let delegate = ServiceDelegate()
let listener = NSXPCListener(machServiceName: Bundle.main.bundleIdentifier!)
listener.delegate = delegate
listener.resume()
