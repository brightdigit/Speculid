import Foundation

public protocol RemoteObjectInterfaceProviderProtocol {
  func remoteObjectProxyWithHandler(_ handler: (Result<ServiceProtocol>) -> Void)
}
