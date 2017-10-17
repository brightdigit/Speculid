
import Foundation
import AppKit
import SwiftVer

var exceptionHandler: ((NSException) -> Void)?

func exceptionHandlerMethod(exception: NSException) {
  if let handler = exceptionHandler {
    handler(exception)
  }
}

public typealias RegularExpressionArgumentSet = (String, options: NSRegularExpression.Options)
open class Application: NSApplication {
  open static var current: Application! {
    return NSApplication.shared as? Application
  }
  open private(set) var statusItem: NSStatusItem!
  open private(set) var service: ServiceProtocol!
  open private(set) var regularExpressions: RegularExpressionSetProtocol!

  open let statusItemProvider: StatusItemProviderProtocol
  open let remoteObjectInterfaceProvider: RemoteObjectInterfaceProviderProtocol
  open let regularExpressionBuilder: RegularExpressionSetBuilderProtocol

  public override init() {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    super.init()
  }

  public required init?(coder: NSCoder) {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    super.init(coder: coder)
  }

  open override func finishLaunching() {
    super.finishLaunching()

    statusItem = statusItemProvider.statusItem(for: self)
    do {
      regularExpressions = try regularExpressionBuilder.buildRegularExpressions(fromDictionary: [
        .geometry: ("x?(\\d+)", options: [.caseInsensitive]),
        .integer: ("\\d+", options: []),
        .scale: ("(\\d+)x", options: []),
        .size: ("(\\d+\\.?\\d*)x(\\d+\\.?\\d*)", options: []),
        .number: ("\\d", options: [])
        /*
         let scaleRegex = try! NSRegularExpression(pattern: "(\\d+)x", options: [])
         let sizeRegex = try! NSRegularExpression(pattern: "(\\d+\\.?\\d*)x(\\d+\\.?\\d*)", options: [])
         let numberRegex = try! NSRegularExpression(pattern: "\\d", options: [])
         */
      ])
    } catch let error {
      assertionFailure("Failed to parse regular expression: \(error)")
    }

    remoteObjectInterfaceProvider.remoteObjectProxyWithHandler { result in
      switch result {
      case let .error(error):
        preconditionFailure("Could not connect to XPS Service.")
        break
      case let .success(service):
        break
      }
    }
  }

  private class _VersionHandler {
  }

  public static let bundle = Bundle(for: _VersionHandler.self)

  public static let vcs = VersionControlInfo(type: VCS_TYPE,
                                             baseName: VCS_BASENAME,
                                             uuid: Hash(string: VCS_UUID!),
                                             number: VCS_NUM,
                                             date: VCS_DATE,
                                             branch: VCS_BRANCH,
                                             tag: VCS_TAG,
                                             tick: VCS_TICK,
                                             extra: VCS_EXTRA,
                                             hash: Hash(string: VCS_FULL_HASH)!,

                                             isWorkingCopyModified: VCS_WC_MODIFIED)

  public static let sbd =
    Stage.dictionary(fromPlistAtURL: Application.bundle.url(forResource: "versions", withExtension: "plist")!)!
  // StageBuildDictionaryProtocol! = nil

  public static let version = Version(
    bundle: bundle,
    dictionary: sbd,
    versionControl: vcs)!

  public static func begin(
    withArguments _: SpeculidArgumentsProtocol,
    _: @escaping (SpeculidApplicationProtocol) -> Void) {
    let operatingSystem = ProcessInfo.processInfo.operatingSystemVersionString

    let analyticsConfiguration = AnalyticsConfiguration(
      trackingIdentifier: "UA-33667276-6",
      applicationName: "speculid",
      applicationVersion: String(describing: version),
      customParameters: [.operatingSystemVersion: operatingSystem])
    let tracker = AnalyticsTracker(configuration: analyticsConfiguration, sessionManager: AnalyticsSessionManager())
    NSSetUncaughtExceptionHandler(exceptionHandlerMethod)

    exceptionHandler = tracker.track

    tracker.track(event: AnalyticsEvent(category: "main", action: "launch", label: "application"))

    let application = SpeculidApplication(configuration: SpeculidConfiguration.default, tracker: tracker)
  }
}
