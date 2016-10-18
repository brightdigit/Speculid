//
//  Speculid.swift
//  speculid
//
//  Created by Leo Dion on 9/29/16.
//
//

import Foundation
import SwiftVer

var exceptionHandler : ((NSException) -> Void)?

func exceptionHandlerMethod(exception : NSException) {
  if let handler = exceptionHandler {
    handler(exception)
  }
}

public struct Speculid {
  private class _VersionHandler {
    
  }
  
  public static let vcs = VersionControlInfo(TYPE: VCS_TYPE, BASENAME: VCS_BASENAME, UUID: VCS_UUID, NUM: VCS_NUM, DATE: VCS_DATE, BRANCH: VCS_BRANCH, TAG: VCS_TAG, TICK: VCS_TICK, EXTRA: VCS_EXTRA, FULL_HASH: VCS_FULL_HASH, SHORT_HASH: VCS_SHORT_HASH, WC_MODIFIED: VCS_WC_MODIFIED)
  public static let version = Version(bundle: Bundle(for: _VersionHandler.self), versionControl: vcs)!
  
  
  public static func begin (withArguments arguments: SpeculidArgumentsProtocol, _ callback: @escaping (SpeculidApplicationProtocol) -> Void) {
    let operatingSystem = ProcessInfo.processInfo.operatingSystemVersionString
    let analyticsConfiguration = AnalyticsConfiguration(trackingIdentifier: "UA-33667276-6", applicationName: "speculid", applicationVersion : String(describing: self.version), customParameters : [.operatingSystemVersion : operatingSystem])
    let tracker = AnalyticsTracker(configuration: analyticsConfiguration, sessionManager: AnalyticsSessionManager())
    NSSetUncaughtExceptionHandler(exceptionHandlerMethod)
    
    exceptionHandler = tracker.track
    
    let configLoader = SpeculidConfigurationLoader(dataSources: [ConfiguredApplicationPathDataSource(), DefaultApplicationPathDataSource()])
    
    tracker.track(event: AnalyticsEvent(category: "main", action: "launch", label: "application"))
    
    configLoader.load { (configuration) in
      let application = SpeculidApplication(configuration: configuration, tracker: tracker)
      fatalError("test")
    }
  }
}
