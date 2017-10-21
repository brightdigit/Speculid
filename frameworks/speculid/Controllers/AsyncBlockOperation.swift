import Foundation

open class AsyncBlockOperation: Operation {
  typealias Block = (() -> Void) -> Void

  private let block: Block
  private var _executing = false
  private var _finished = false

  init(block: @escaping Block) {
    self.block = block
    super.init()
  }

  open override func start() {
    guard (isExecuting || isCancelled) == false else { return }
    _executing = true
    block(finish)
  }

  private func finish() {
    _executing = false
    _finished = true

    if let completionBlock = self.completionBlock {
      DispatchQueue.main.async(execute: completionBlock)
    }
  }

  open override var isAsynchronous: Bool {
    return true
  }

  open override var isExecuting: Bool {
    get { return _executing }
    set {
      let key = "isExecuting"
      willChangeValue(forKey: key)
      _executing = newValue
      didChangeValue(forKey: key)
    }
  }

  open override var isFinished: Bool {
    get { return _finished }
    set {
      let key = "isFinished"
      willChangeValue(forKey: key)
      _finished = newValue
      didChangeValue(forKey: key)
    }
  }
}
