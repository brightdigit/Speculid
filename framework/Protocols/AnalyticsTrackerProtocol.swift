//
//  AnalyticsProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsTrackerProtocol {
  func track(time: TimeInterval, withCategory: String?, withLabel: String?)
}
