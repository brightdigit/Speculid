//
//  ProcessImageConversionTask.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

@available(*, deprecated: 2.0.0)
public struct ProcessImageConversionTask : ImageConversionTaskProtocol {
  public func start(callback: @escaping (Error?) -> Void) {
    process.launch(callback)
  }
  
  public let process: ProcessProtocol
}
