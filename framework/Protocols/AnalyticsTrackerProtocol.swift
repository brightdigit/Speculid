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
  var value : String? { get }
}

public protocol AnalyticsTrackerProtocol {
  func track(time: TimeInterval, withCategory: String?, withLabel: String?)
  
  func track(event: AnalyticsEventProtocol)
}
