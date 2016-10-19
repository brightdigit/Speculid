//
//  AnalyticsEventProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

import Foundation

public protocol AnalyticsEventProtocol {
  var category : String { get }
  var action : String { get }
  var label : String? { get }
  var value : Int? { get }
}
