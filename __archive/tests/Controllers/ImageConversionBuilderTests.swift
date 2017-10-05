//
//  ImageConversionBuilderTests.swift
//  speculid
//
//  Created by Leo Dion on 10/4/16.
//
//

import XCTest
@testable import Speculid

var count = 0

struct MockImageConverter : ImageConversionBuilderProtocol {
  public let value = arc4random_uniform(UINT32_MAX)
  func conversion(forImage imageSpecification: ImageSpecificationProtocol, withSpecifications specifications: SpeculidSpecificationsProtocol, andConfiguration configuration: SpeculidConfigurationProtocol) -> ConversionResult? {
    count = count + 1
    return ConversionResult.Error(UInt32(value))
  }
}

class ImageConversionBuilderTests: XCTestCase {

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
      let builderChild = MockImageConverter()
      let builder = ImageConversionBuilder(builders: [builderChild])
      let bundle = Bundle(for: type(of: self))
      
      let taskOrErrorsOpt = builder.conversion(forImage: ImageSpecification(idiom: .watch, scale: nil, size: nil, filename: nil) , withSpecifications: SpeculidSpecifications(contentsDirectoryURL: bundle.bundleURL, sourceImageURL: bundle.bundleURL), andConfiguration: SpeculidConfiguration())
      
      guard let taskOrErrors = taskOrErrorsOpt else {
        return XCTFail()
      }
      
      guard case let .Error(error) = taskOrErrors else {
        return XCTFail()
      }
      
      guard let value = error as? UInt32 else {
        return XCTFail()
      }
      
      XCTAssertEqual(builderChild.value, value)
      XCTAssertEqual(count, 1)
    }
}
