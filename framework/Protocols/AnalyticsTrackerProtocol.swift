//
//  AnalyticsProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsTrackerProtocol {
  func track(time: TimeInterval, withCategory category: String, withVariable variable: String, withLabel label: String?)
  
  func track(event: AnalyticsEventProtocol)
  
  func track(error: Error, isFatal: Bool)
}

public extension AnalyticsTrackerProtocol {
  func track(exception: NSException) {
    self.track(error: exception, isFatal: true)
  }
}

extension NSException : Error {
  
}
