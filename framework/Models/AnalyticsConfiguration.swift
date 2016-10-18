//
//  AnalyticsConfiguration.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

public struct AnalyticsConfiguration: AnalyticsConfigurationProtocol {
  public let version = 1
  public let trackingIdentifier: String
  public let clientIdentifier: String
  public let applicationName : String
  public let applicationVersion : String
  
  public init (trackingIdentifier: String, applicationName : String, applicationVersion : String, clientIdentifierDelegate: ClientIdentifierDelegate? = nil) {
    self.trackingIdentifier = trackingIdentifier
    self.applicationVersion = applicationVersion
    self.applicationName = applicationName
    self.clientIdentifier = clientIdentifierDelegate?.clientIdentifier ?? ClientIdentifier.shared.clientIdentifier
  }
}
