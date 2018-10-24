import Foundation

public protocol RemoteObjectInterfaceProviderProtocol {
  func remoteObjectProxyWithHandler(_ handler: (Result<ServiceProtocol>) -> Void)
}

public protocol InstallerObjectInterfaceProviderProtocol {
  func remoteObjectProxyWithHandler(_ handler: (Result<InstallerProtocol>) -> Void)
}
