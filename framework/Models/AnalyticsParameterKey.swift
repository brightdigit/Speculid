//
//  AnalyticsParameterKey.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

public enum AnalyticsParameterKey : String {
  case hitType = "t", version = "v", trackingId = "tid",
  userTimingCategory = "utc", userTimingLabel = "utl", timing = "utt", clientId = "cid",
  userTimingVariable = "utv",
  applicationName = "an", applicationVersion = "av", eventAction = "ea",
  eventCategory = "ec", eventLabel = "el", eventValue = "ev",
  userLanguage = "ul", operatingSystemVersion = "cd1",
  exceptionDescription = "exd", exceptionFatal = "exf"
}
