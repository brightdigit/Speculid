import Foundation

public struct NoServiceReturnedError: Error {}

public struct RemoteObjectInterfaceProvider: RemoteObjectInterfaceProviderProtocol {
  public func remoteObjectProxyWithHandler(_ handler: (Result<ServiceProtocol>) -> Void) {
    let interface = NSXPCInterface(with: ServiceProtocol.self)
    let connection = NSXPCConnection(serviceName: "com.brightdigit.Speculid-Mac-XPC")

    connection.remoteObjectInterface = interface
    connection.resume()

    var error: Error?

    let proxy = connection.remoteObjectProxyWithErrorHandler { handlerError in
      error = handlerError
    }

    let result: Result<ServiceProtocol>

    if let error = error {
      result = .error(error)
    } else if let service = proxy as? ServiceProtocol {
      result = .success(service)
    } else {
      result = .error(NoServiceReturnedError())
    }

    handler(result)
  }
}
