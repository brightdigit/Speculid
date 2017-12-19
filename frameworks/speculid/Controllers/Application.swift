import AppKit
import Foundation
import SwiftVer

var exceptionHandler: ((NSException) -> Void)?

func exceptionHandlerMethod(exception: NSException) {
  if let handler = exceptionHandler {
    handler(exception)
  }
}

public typealias RegularExpressionArgumentSet = (String, options: NSRegularExpression.Options)
open class Application: NSApplication, ApplicationProtocol {
  public func document(url: URL) throws -> SpeculidDocumentProtocol {
    return try SpeculidDocument(url: url, decoder: jsonDecoder, configuration: configuration)
  }

  open static var current: ApplicationProtocol! {
    return NSApplication.shared as? ApplicationProtocol
  }

  open static let errorText = "Unknown Command Paramter"
  open static let helpText: String! = {
    guard let url = Application.bundle.url(forResource: "help", withExtension: "txt") else {
      return nil
    }

    guard let text = try? String(contentsOf: url) else {
      return nil
    }

    return text
  }()
  open private(set) var commandLineActivity: CommandLineActivityProtocol?
  open private(set) var statusItem: NSStatusItem?
  open private(set) var service: ServiceProtocol!
  open private(set) var regularExpressions: RegularExpressionSetProtocol!
  open private(set) var tracker: AnalyticsTrackerProtocol!
  open private(set) var configuration: SpeculidConfigurationProtocol!
  open private(set) var builder: SpeculidBuilderProtocol!

  open let statusItemProvider: StatusItemProviderProtocol
  open let remoteObjectInterfaceProvider: RemoteObjectInterfaceProviderProtocol
  open let regularExpressionBuilder: RegularExpressionSetBuilderProtocol
  open let configurationBuilder: SpeculidConfigurationBuilderProtocol
  open let jsonDecoder: JSONDecoder
  open let imageSpecificationBuilder: SpeculidImageSpecificationBuilderProtocol
  open var commandLineRunner: CommandLineRunnerProtocol

  public override init() {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    configurationBuilder = SpeculidConfigurationBuilder()
    jsonDecoder = JSONDecoder()
    imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    commandLineRunner = CommandLineRunner(
      outputStream: FileHandle.standardOutput,
      errorStream: FileHandle.standardError)

    super.init()
  }

  public required init?(coder: NSCoder) {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    configurationBuilder = SpeculidConfigurationBuilder(coder: coder)
    jsonDecoder = JSONDecoder()
    imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    commandLineRunner = CommandLineRunner(
      outputStream: FileHandle.standardOutput,
      errorStream: FileHandle.standardError)

    super.init(coder: coder)
  }

  open override func finishLaunching() {
    super.finishLaunching()

    configuration = configurationBuilder.configuration(fromCommandLine: CommandLineArgumentProvider())

    let operatingSystem = ProcessInfo.processInfo.operatingSystemVersionString

    let analyticsConfiguration = AnalyticsConfiguration(
      trackingIdentifier: "UA-33667276-6",
      applicationName: "speculid",
      applicationVersion: String(describing: Application.version),
      customParameters: [.operatingSystemVersion: operatingSystem])

    remoteObjectInterfaceProvider.remoteObjectProxyWithHandler { result in
      switch result {
      case let .error(error):
        preconditionFailure("Could not connect to XPS Service: \(error)")
      case let .success(service):
        self.service = service
      }
    }

    builder = SpeculidBuilder(tracker: self.tracker, configuration: configuration, imageSpecificationBuilder: imageSpecificationBuilder)
    let tracker = AnalyticsTracker(configuration: analyticsConfiguration, sessionManager: AnalyticsSessionManager())
    NSSetUncaughtExceptionHandler(exceptionHandlerMethod)

    exceptionHandler = tracker.track

    tracker.track(event: AnalyticsEvent(category: "main", action: "launch", label: "application"))

    self.tracker = tracker

    do {
      regularExpressions = try regularExpressionBuilder.buildRegularExpressions(fromDictionary: [
        .geometry: ("x?(\\d+)", options: [.caseInsensitive]),
        .integer: ("\\d+", options: []),
        .scale: ("(\\d+)x", options: []),
        .size: ("(\\d+\\.?\\d*)x(\\d+\\.?\\d*)", options: []),
        .number: ("\\d", options: [])
      ])
    } catch let error {
      assertionFailure("Failed to parse regular expression: \(error)")
    }

    if case let .command(arguments) = configuration.mode {
      let commandLineActivity = self.commandLineRunner.activity(withArguments: arguments, self.commandLineActivity(_:hasCompletedWithError:))
      self.commandLineActivity = commandLineActivity
      commandLineActivity.start()
      return
    }

    statusItem = statusItemProvider.statusItem(for: self)
  }

  public func commandLineActivity(_: CommandLineActivityProtocol, hasCompletedWithError error: Error?) {

    precondition(error == nil, error!.localizedDescription)
    exit(0)
  }

  public func quit(_ sender: Any?) {
    terminate(sender)
  }

  public static let bundle = Bundle(for: Application.self)

  public static let vcs = VersionControlInfo(jsonResource: "autorevision", fromBundle: Application.bundle)

  public static let sbd =
    Stage.dictionary(fromPlistAtURL: Application.bundle.url(forResource: "versions", withExtension: "plist")!)!

  public let version = Version(
    bundle: bundle,
    dictionary: sbd,
    versionControl: vcs)
}
