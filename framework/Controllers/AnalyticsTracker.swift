//
//  AnalyticsTracker.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public enum AnalyticsHitType : String {
  case timing = "timing"
}

public struct AnalyticsTracker : AnalyticsTrackerProtocol {
  let configuration : AnalyticsConfigurationProtocol
  let sessionManager : AnalyticsSessionManagerProtocol
  
  public func track(time: TimeInterval, withCategory category: String?, withLabel label: String?) {
    var parameters = configuration.parameters
    
    parameters[.hitType] = AnalyticsHitType.timing
    parameters[.category] = category
    parameters[.label] = label
    parameters[.timing] = time
    
    sessionManager.send(parameters)
  }
}
