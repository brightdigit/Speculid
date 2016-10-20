//
//  ApplicationPathDataSourceTest.swift
//  speculid
//
//  Created by Leo Dion on 10/19/16.
//
//

import XCTest
@testable import Speculid

public struct MockApplicationPathDataSource : ApplicationPathDataSource {
  public func applicationPaths(_ closure: @escaping (ApplicationPathDictionary) -> Void) {
    closure(self.applicationPaths)
  }

  public let applicationPaths : ApplicationPathDictionary
  
}

class ApplicationPathDataSourceTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testLoad() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let expectation = self.expectation(description: "Waiting for loading to finish")
    let dictionary : ApplicationPathDictionary = [.inkscape : URL.random(), .convert : URL.random()]
    let loader = SpeculidConfigurationLoader(dataSources: [MockApplicationPathDataSource(applicationPaths: dictionary)])
    loader.load { (configuration) in
      XCTAssertEqual(configuration.applicationPaths, dictionary)
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 5.0) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
