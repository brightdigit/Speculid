//
//  ProcessImageConversionTask.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public struct ProcessError : Error, CustomStringConvertible {
  public let process : Process
  public let message : String
  
  public var localizedDescription: String {
    return message
  }
  
  public var description: String {
    return message
  }
}

public struct ProcessImageConversionTask : ImageConversionTaskProtocol {
  public func start(callback: @escaping (Error?) -> Void) {
 
      
      let pipe = Pipe()
      self.process.standardError = pipe
      let fileHandle = pipe.fileHandleForReading
      self.process.terminationHandler = {
        (process) in
        let error : Error?
        if case .uncaughtSignal = process.terminationReason {
          let data = fileHandle.readDataToEndOfFile()
          let text = String(data: data, encoding: .utf8)!
          error = ProcessError(process: process, message: text)
        } else {
          error = nil
        }
        callback(error)
      }
      self.process.launch()
    
   
  }

  public let process: Process
}
