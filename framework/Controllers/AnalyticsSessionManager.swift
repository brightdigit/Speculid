//
//  AnalyticsSessionManager.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

public struct AnalyticsSessionManager: AnalyticsSessionManagerProtocol {
  public static let defaultBaseUrl = URL(string: "https://www.google-analytics.com/collect")!
  
  public let baseUrl : URL
  
  public init (baseUrl : URL? = nil) {
    self.baseUrl = baseUrl ?? AnalyticsSessionManager.defaultBaseUrl
  }
  
  public func send(_ parameters: AnalyticsParameterDictionary) {
    
  }
}
