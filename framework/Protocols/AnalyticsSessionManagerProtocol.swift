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
  userTimingCategory = "utc", userTimingLabel = "utl", timing = "utt", clientId = "cid",
  userTimingVariable = "utv",
  applicationName = "an", applicationVersion = "av", eventAction = "ea",
  eventCategory = "ec", eventLabel = "el", eventValue = "ev",
  userLanguage = "ul", operatingSystemVersion = "cd1"
}

public typealias AnalyticsParameterDictionary = [AnalyticsParameterKey : Any]

public protocol AnalyticsSessionManagerProtocol {
  func send (_ parameters : AnalyticsParameterDictionary)
}
