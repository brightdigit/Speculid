//
//  AnalyticsProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsEventProtocol {
  var category : String { get }
  var action : String { get }
  var label : String? { get }
  var value : Int? { get }
}

public protocol AnalyticsTrackerProtocol {
  func track(time: TimeInterval, withCategory category: String, withVariable variable: String, withLabel label: String?)
  
  func track(event: AnalyticsEventProtocol)
}
