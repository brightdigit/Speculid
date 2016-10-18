//
//  AnalyticsConfigurationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsConfigurationProtocol {
  var applicationVersion : String { get }
  var applicationName : String { get }
  var trackingIdentifier : String { get }
  var clientIdentifier : String { get }
  var version : Int { get }
}

public extension AnalyticsConfigurationProtocol {
  public var parameters : AnalyticsParameterDictionary {
    return [.trackingId : self.trackingIdentifier, .clientId: self.clientIdentifier, .version : self.version, .applicationName: self.applicationName, .applicationVersion : self.applicationVersion]
  }
}
