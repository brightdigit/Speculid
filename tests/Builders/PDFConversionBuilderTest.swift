//
//  PDFConversionBuilderTest.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

import XCTest
import RandomKit
@testable import Speculid

class PDFConversionBuilderTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testConversionWithScale () {
    let imageSpec = ImageSpecification(idiom: .universal, scale: 2.0, size: nil, filename: nil)
    let inkscapeURL = URL.random()
    
    let configuration = SpeculidConfiguration(applicationPaths : [.inkscape : inkscapeURL])
    let contentsDirectoryURL = URL.random()
    let sourceImageURL = URL.random()
    let specs = SpeculidSpecifications(contentsDirectoryURL: contentsDirectoryURL, sourceImageURL: sourceImageURL)
    let builder = PDFConversionBuilder()
    
    let result = builder.conversion(forImage: imageSpec, withSpecifications: specs, andConfiguration: configuration)
    
    XCTAssertNotNil(imageSpec.scale)
    XCTAssertEqual(configuration.inkscapeURL, inkscapeURL)
    XCTAssertNil(result)
    
  }
  
  func testConversionWithNoInkscape () {
    
    let imageSpec = ImageSpecification(idiom: .universal, scale: nil, size: nil, filename: nil)
    
    let configuration = SpeculidConfiguration()
    let contentsDirectoryURL = URL.random()
    let sourceImageURL = URL.random()
    let specs = SpeculidSpecifications(contentsDirectoryURL: contentsDirectoryURL, sourceImageURL: sourceImageURL)
    let builder = PDFConversionBuilder()
    
    XCTAssertNil(imageSpec.scale)
    XCTAssertNil(configuration.inkscapeURL)
    
    guard let result = builder.conversion(forImage: imageSpec, withSpecifications: specs, andConfiguration: configuration)  else {
      XCTFail("no result returned")
      return
    }
    
    guard case .Error(let error) = result else {
      XCTFail("result is not error")
      return
    }
    
    guard let missingReqError = error as? MissingRequiredInstallationError else {
      XCTFail("error is not right type")
      return
    }
    
    XCTAssertEqual(missingReqError.name, "inkscape")
  }
  
  func testConversionSuccess () {
    let inkscapeURL = URL.random()
    let imageSpecification = ImageSpecification(idiom: .universal, scale: nil, size: nil, filename: nil)
    
    let configuration = SpeculidConfiguration(applicationPaths : [.inkscape : inkscapeURL])
    let contentsDirectoryURL = URL.random()
    let sourceImageURL = URL.random()
    let specifications = SpeculidSpecifications(contentsDirectoryURL: contentsDirectoryURL, sourceImageURL: sourceImageURL)
    let builder = PDFConversionBuilder()
    
    
    guard let result = builder.conversion(forImage: imageSpecification, withSpecifications: specifications, andConfiguration: configuration)  else {
      XCTFail("no result returned")
      return
    }
    
    guard case .Task(let task) = result else {
      XCTFail("result is not task")
      return
    }
    
    
    guard let processTask = task as? ProcessImageConversionTask else {
      XCTFail("task is not a process task")
      return
    }
    
    guard let process = processTask.process as? Process else {
      XCTFail("process task is not a process")
      return
    }
    
    
    XCTAssertEqual(process.launchPath, inkscapeURL.path)
    
    XCTAssertEqual(process.arguments!, ["--without-gui","--export-area-drawing","--export-pdf",
                   specifications.contentsDirectoryURL.appendingPathComponent(specifications.destination(forImage: imageSpecification)).path,specifications.sourceImageURL.absoluteURL.path])
  }
}
