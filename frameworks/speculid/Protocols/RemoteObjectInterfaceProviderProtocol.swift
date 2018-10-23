import Foundation

public protocol RemoteObjectInterfaceProviderProtocol where ProxyType: Protocol {
  associatedtype ProxyType
  func remoteObjectProxyWith(serviceName: String, andHandler handler: (Result<ProxyType>) -> Void)
}

public protocol ServiceObjectInterfaceProvider {
  func remoteObjectProxyWithHandler(_ handler: (Result<ServiceProtocol>) -> Void)
}
