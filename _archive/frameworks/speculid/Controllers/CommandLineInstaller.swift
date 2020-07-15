import Foundation
import Security
import ServiceManagement

struct TimeoutError: Error {}
struct OSStatusError: Error {
  let osStatus: OSStatus
}

public struct CommandLineInstaller {
  public static func start(_ completed: @escaping (Error?) -> Void) {
    var authorizationRef: AuthorizationRef?

    var items = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value: nil, flags: 0)

    var rights = AuthorizationRights(count: 1, items: &items)
    let flags: AuthorizationFlags = [.interactionAllowed, .extendRights, .preAuthorize]

    let osStatus = AuthorizationCreate(&rights, nil, flags, &authorizationRef)

    guard osStatus == errAuthorizationSuccess else {
      completed(OSStatusError(osStatus: osStatus))
      return
    }

    var cfError: Unmanaged<CFError>?
    let result = SMJobBless(kSMDomainSystemLaunchd, "com.brightdigit.Speculid-Mac-Installer" as CFString, authorizationRef, &cfError)

    guard result else {
      completed(cfError?.takeRetainedValue())
      return
    }
    Application.current.withInstaller {
      result in

      switch result {
      case let .success(installer):
        installer.installCommandLineTool(fromBundleURL: Bundle.main.bundleURL) { error in
          debugPrint(error)
          var cfError: Unmanaged<CFError>?
          SMJobRemove(kSMDomainSystemLaunchd, "com.brightdigit.Speculid-Mac-Installer" as CFString, authorizationRef, true, &cfError)
          completed(error)
        }
      case let .error(error):
        debugPrint(error)
        completed(nil)
      }
    }
  }
}

extension CommandLineInstaller {
  public static func startSync() -> Error? {
    var error: Error?
    let semaphore = DispatchSemaphore(value: 0)
    start {
      error = $0
      semaphore.signal()
    }
    let result = semaphore.wait(timeout: .now() + 10)
    if let error = error {
      return error
    } else {
      switch result {
      case .success:
        return nil
      case .timedOut:
        return TimeoutError()
      }
    }
  }
}
