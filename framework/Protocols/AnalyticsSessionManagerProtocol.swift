//
//  AnalyticsSessionManagerProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol AnalyticsSessionManagerProtocol {
  func send (_ parameters : AnalyticsParameterDictionary)
}
