//
//  AnalyticsSessionManagerProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public enum AnalyticsParameterKey : String {
  
  case hitType = "t", version = "v", trackingId = "tid",
  category = "utc", label = "utl", timing = "utt"
  
}

public typealias AnalyticsParameterDictionary = [AnalyticsParameterKey : Any]

public protocol AnalyticsSessionManagerProtocol {
  func send (_ parameters : AnalyticsParameterDictionary)
}
