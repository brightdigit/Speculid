import XCTest
@testable import Speculid

class RecordedOutputStream: TextOutputStream {
  public private(set) var strings = [String]()
  func write(_ string: String) {
    strings.append(string)
  }
}

class CommandLineRunnerTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testHelp() {
    let expectation = XCTestExpectation(description: "Run Command Line Activity")
    let outputStream = RecordedOutputStream()
    let errorStream = RecordedOutputStream()
    let argument = SpeculidCommandArgumentSet.help
    let commandLineRunner = CommandLineRunner(outputStream: outputStream, errorStream: errorStream)

    let activity = commandLineRunner.activity(withArguments: argument) { activity, error in
      XCTAssertNotNil(activity)
      XCTAssertNil(error)
      XCTAssertEqual(
        outputStream.strings,
        [Application.helpText])
      XCTAssertEqual(errorStream.strings, [])
      expectation.fulfill()
    }

    activity.start()
    wait(for: [expectation], timeout: 10.0)
  }

  func testVersion() {
    let expectation = XCTestExpectation(description: "Run Command Line Activity")
    let outputStream = RecordedOutputStream()
    let errorStream = RecordedOutputStream()
    let argument = SpeculidCommandArgumentSet.version
    let commandLineRunner = CommandLineRunner(outputStream: outputStream, errorStream: errorStream)

    let activity = commandLineRunner.activity(withArguments: argument) { activity, error in
      XCTAssertNotNil(activity)
      XCTAssertNil(error)
      XCTAssertEqual(
        outputStream.strings,
        ["Speculid v\(Application.version.shortDescription) [\(Application.version)]"])
      XCTAssertEqual(errorStream.strings, [])
      expectation.fulfill()
    }

    activity.start()

    wait(for: [expectation], timeout: 10.0)
  }
}
