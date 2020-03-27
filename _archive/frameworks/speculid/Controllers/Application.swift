import AppKit
import Foundation
import SwiftVer

extension OperatingSystemVersion {
  var fullDescription: String {
    [majorVersion, minorVersion, patchVersion].map {
      String(describing: $0)
    }.joined(separator: ".")
  }
}

var exceptionHandler: ((NSException) -> Void)?

func exceptionHandlerMethod(exception: NSException) {
  if let handler = exceptionHandler {
    handler(exception)
  }
}

public typealias RegularExpressionArgumentSet = (String, options: NSRegularExpression.Options)
open class Application: NSApplication, ApplicationProtocol {
  public func withInstaller(_ completed: (Result<InstallerProtocol>) -> Void) {
    installerObjectInterfaceProvider.remoteObjectProxyWithHandler(completed)
  }

  public func documents(url: URL) throws -> [SpeculidDocumentProtocol] {
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
    if exists, isDirectory.boolValue == true {
      guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) else {
        throw InvalidDocumentURL(url: url)
      }
      return enumerator.compactMap { (item) -> SpeculidDocument? in
        guard let url = item as? URL else {
          return nil
        }
        return try? SpeculidDocument(url: url, decoder: jsonDecoder, configuration: configuration)
      }
    } else {
      return [try SpeculidDocument(url: url, decoder: jsonDecoder, configuration: configuration)]
    }
  }

  public static var current: ApplicationProtocol! {
    NSApplication.shared as? ApplicationProtocol
  }

  public static let unknownCommandMessagePrefix = "Unknown Command Arguments"

  public static func unknownCommandMessage(fromArguments arguments: [String]) -> String {
    "\(unknownCommandMessagePrefix): \(arguments.joined(separator: " "))"
  }

  public static let helpText: String! = {
    guard let url = Application.bundle.url(forResource: "help", withExtension: "txt") else {
      return nil
    }

    guard let format = try? String(contentsOf: url) else {
      return nil
    }

    let text: String

    if let sourceApplicationName = ProcessInfo.processInfo.environment["sourceApplicationName"] ?? Bundle.main.executableURL?.lastPathComponent {
      text = format.replacingOccurrences(of: "$ speculid", with: "$ " + sourceApplicationName)
    } else {
      text = format
    }

    return text
  }()
  open private(set) var commandLineActivity: CommandLineActivityProtocol?
  open private(set) var statusItem: NSStatusItem?
  open private(set) var service: ServiceProtocol!
  open private(set) var installer: InstallerProtocol!
  open private(set) var regularExpressions: RegularExpressionSetProtocol!
  open private(set) var tracker: AnalyticsTrackerProtocol!
  open private(set) var configuration: SpeculidConfigurationProtocol!
  open private(set) var builder: SpeculidBuilderProtocol!

  public let statusItemProvider: StatusItemProviderProtocol
  public let remoteObjectInterfaceProvider: RemoteObjectInterfaceProviderProtocol
  public let installerObjectInterfaceProvider: InstallerObjectInterfaceProviderProtocol
  public let regularExpressionBuilder: RegularExpressionSetBuilderProtocol
  public let configurationBuilder: SpeculidConfigurationBuilderProtocol
  public let jsonDecoder: JSONDecoder
  public let imageSpecificationBuilder: SpeculidImageSpecificationBuilderProtocol
  open var commandLineRunner: CommandLineRunnerProtocol

  public override init() {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    installerObjectInterfaceProvider = InstallerObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    configurationBuilder = SpeculidConfigurationBuilder()
    jsonDecoder = JSONDecoder()
    imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    commandLineRunner = CommandLineRunner(
      outputStream: FileHandle.standardOutput,
      errorStream: FileHandle.standardError
    )

    super.init()
  }

  public required init?(coder: NSCoder) {
    statusItemProvider = StatusItemProvider()
    remoteObjectInterfaceProvider = RemoteObjectInterfaceProvider()
    installerObjectInterfaceProvider = InstallerObjectInterfaceProvider()
    regularExpressionBuilder = RegularExpressionSetBuilder()
    configurationBuilder = SpeculidConfigurationBuilder(coder: coder)
    jsonDecoder = JSONDecoder()
    imageSpecificationBuilder = SpeculidImageSpecificationBuilder()
    commandLineRunner = CommandLineRunner(
      outputStream: FileHandle.standardOutput,
      errorStream: FileHandle.standardError
    )

    super.init(coder: coder)
  }

  open override func finishLaunching() {
    super.finishLaunching()

    configuration = configurationBuilder.configuration(fromCommandLine: CommandLineArgumentProvider())

    let operatingSystem = ProcessInfo.processInfo.operatingSystemVersion.fullDescription
    let applicationVersion: String
    if let version = self.version {
      applicationVersion = (try? version.fullDescription(withLocale: nil)) ?? ""
    } else {
      applicationVersion = ""
    }

    let analyticsConfiguration = AnalyticsConfiguration(
      trackingIdentifier: "UA-33667276-6",
      applicationName: "speculid",
      applicationVersion: applicationVersion,
      customParameters: [.operatingSystemVersion: operatingSystem, .model: Sysctl.model]
    )

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
    } catch {
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
    if let error = error {
      FileHandle.standardError.write(error.localizedDescription)
      exit(1)
    } else {
      exit(0)
    }
  }

  public func quit(_ sender: Any?) {
    terminate(sender)
  }

  public static var author: String {
    bundle.bundleIdentifier!.components(separatedBy: "-").first!
  }

  public static let bundle = Bundle(for: Application.self)

  public static let vcs = VersionControlInfo(jsonResource: "autorevision", fromBundle: Application.bundle)

  public static let sbd =
    Stage.dictionary(fromPlistAtURL: Application.bundle.url(forResource: "versions", withExtension: "plist")!)!

  public let version = Version(
    bundle: bundle,
    dictionary: sbd,
    versionControl: vcs
  )
}
