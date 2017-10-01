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

public class SerialProcessCollection {
  public let processes : [ProcessProtocol]
  public var index = -1
  public let callback: (Error?) -> Void
  
  public init (processes: [ProcessProtocol], callback: @escaping (Error?) -> Void) {
    self.processes = processes
    self.callback = callback
  }
  
  public func start () {
    next(error: nil)
  }
  
  public func next (error: Error?) {
    self.index = self.index + 1
    if let error = error {
      self.callback(error)
    } else if self.index < self.processes.count {
      self.processes[self.index].launch(self.next)
    } else {
      self.callback(nil)
    }
  }
}

public struct SerialProcess : ProcessProtocol {
  public let processes : [ProcessProtocol]
  
  public func launch(_ callback: @escaping (Error?) -> Void) {
    let collection = SerialProcessCollection(processes: self.processes, callback: callback)
    collection.start()
  }
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
