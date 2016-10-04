//
//  ProcessProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/4/16.
//
//

import Foundation

public protocol ProcessProtocol {
  func launch (_ callback: @escaping (Error?) -> Void)
}

extension Process : ProcessProtocol {
  public func launch (_ callback: @escaping (Error?) -> Void) {
    let pipe = Pipe()
    self.standardError = pipe
    let fileHandle = pipe.fileHandleForReading
    self.terminationHandler = {
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
    self.launch()
  }
}
