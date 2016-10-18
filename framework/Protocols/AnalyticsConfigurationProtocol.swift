//
//  AnalyticsConfigurationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsConfigurationProtocol {
  var identifier : String { get }
  var version : Int { get }
}

public extension AnalyticsConfigurationProtocol {
  public var parameters : AnalyticsParameterDictionary {
    return [.trackingId : self.identifier, .version : self.version]
  }
}
