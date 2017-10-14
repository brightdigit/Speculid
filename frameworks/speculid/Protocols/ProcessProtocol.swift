import Foundation

@available(*, deprecated: 2.0.0)
public protocol ProcessProtocol {
  func launch(_ callback: @escaping (Error?) -> Void)
}

@available(*, deprecated: 2.0.0)
public class SerialProcessCollection {
  public let processes: [ProcessProtocol]
  public var index = -1
  public let callback: (Error?) -> Void

  public init(processes: [ProcessProtocol], callback: @escaping (Error?) -> Void) {
    self.processes = processes
    self.callback = callback
  }

  public func start() {
    next(error: nil)
  }

  public func next(error: Error?) {
    index += 1
    if let error = error {
      callback(error)
    } else if index < processes.count {
      processes[self.index].launch(next)
    } else {
      callback(nil)
    }
  }
}

@available(*, deprecated: 2.0.0)
public struct SerialProcess: ProcessProtocol {
  public let processes: [ProcessProtocol]

  public func launch(_ callback: @escaping (Error?) -> Void) {
    let collection = SerialProcessCollection(processes: processes, callback: callback)
    collection.start()
  }
}

extension Process: ProcessProtocol {
  public func launch(_ callback: @escaping (Error?) -> Void) {
    let pipe = Pipe()
    standardError = pipe
    let fileHandle = pipe.fileHandleForReading
    terminationHandler = {
      process in
      let error: Error?
      if case .uncaughtSignal = process.terminationReason {
        let data = fileHandle.readDataToEndOfFile()
        let text = String(data: data, encoding: .utf8)!
        error = ProcessError(process: process, message: text)
      } else {
        error = nil
      }
      callback(error)
    }
    launch()
  }
}
