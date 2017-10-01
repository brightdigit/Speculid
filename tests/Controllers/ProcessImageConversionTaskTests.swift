//
//  ProcessImageConversionTaskTests.swift
//  speculid
//
//  Created by Leo Dion on 10/4/16.
//
//

import XCTest
@testable import Speculid

extension UInt32 : Error {
  
}

public struct MockProcess : ProcessProtocol {
  public func launch(_ callback: @escaping (Error?) -> Void) {
    callback(self.error)
  }
  
  public let error: Error?
}

class ProcessImageConversionTaskTests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.   
    let count = Int(arc4random_uniform(10))
    
    let mockProcesses = (0...count).map{index -> (MockProcess, XCTestExpectation) in
      let isNil = arc4random_uniform(UINT32_MAX) % UInt32(2) > 0
      let value : UInt32? = isNil ? nil : arc4random_uniform(UINT32_MAX)
      let p = MockProcess(error: value)
      let exp = self.expectation(description: "\(index): \(value)" )
      return (p,exp)
    }
    
    mockProcesses.forEach { (process, expectation) in
      let task = ProcessImageConversionTask(process: process)
      task.start(callback: { (error) in
        if let expected = process.error as? UInt32, let actual = error as? UInt32 {
          XCTAssertEqual(expected, actual)
        } else {
          XCTAssertNil(error)
          XCTAssertNil(process.error)
        }
        expectation.fulfill()
      })
    }
    
    self.waitForExpectations(timeout: TimeInterval(count), handler: nil)
  }
}
