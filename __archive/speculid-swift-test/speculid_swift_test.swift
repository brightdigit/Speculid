//
//  speculid_swift_test.swift
//  speculid-swift-test
//
//  Created by Leo Dion on 9/28/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

import XCTest
@testable import speculid_swift

class speculid_swift_test: XCTestCase {
    
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
      SwiftClass.test()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
