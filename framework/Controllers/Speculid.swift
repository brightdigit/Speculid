//
//  Speculid.swift
//  speculid
//
//  Created by Leo Dion on 9/29/16.
//
//

import Foundation
import SwiftVer

public struct Speculid {
  private class _VersionHandler {
    
  }
  
  public static let vcs = VersionControlInfo(TYPE: VCS_TYPE, BASENAME: VCS_BASENAME, UUID: VCS_UUID, NUM: VCS_NUM, DATE: VCS_DATE, BRANCH: VCS_BRANCH, TAG: VCS_TAG, TICK: VCS_TICK, EXTRA: VCS_EXTRA, FULL_HASH: VCS_FULL_HASH, SHORT_HASH: VCS_SHORT_HASH, WC_MODIFIED: VCS_WC_MODIFIED)
  public static let version = Version(bundle: Bundle(for: _VersionHandler.self), versionControl: vcs)!
  
  
  public static func begin (withArguments arguments: SpeculidArgumentsProtocol, _ callback: @escaping (SpeculidApplicationProtocol) -> Void) {
    
    let analyticsConfiguration = AnalyticsConfiguration(identifier: "UA-33667276-6")
    let tracker = AnalyticsTracker(configuration: analyticsConfiguration, sessionManager: AnalyticsSessionManager())
    let configLoader = SpeculidConfigurationLoader(dataSources: [ConfiguredApplicationPathDataSource(), DefaultApplicationPathDataSource()])
    
    //tracker.trackEvent(ofCategory: "Launch", action: "Application Launch", label: "Launch Event", value: NSNumber(value: 0))
    
    configLoader.load { (configuration) in
      let application = SpeculidApplication(configuration: configuration, tracker: tracker)
      callback(application)
    }
  }
}
