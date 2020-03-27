@testable import SpeculidKit
import SwiftVer
import XCTest

class RecordedOutputStream: TextOutputStream {
  public private(set) var strings = [String]()
  func write(_ string: String) {
    strings.append(string)
  }
}

struct MockVersionProvider: VersionProvider {
  public static let vcs = VersionControlInfo(jsonResource: "autorevision", fromBundle: Application.bundle)

  public static let sbd =
    Stage.dictionary(fromPlistAtURL: Application.bundle.url(forResource: "versions", withExtension: "plist")!)!

  public let version = Version(
    bundle: Application.bundle,
    dictionary: sbd,
    versionControl: vcs
  )
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

  func testUnknown() {
    let argumentStrings = (0 ..< 100).map { _ in String.randomAlphanumeric(ofLength: 100) }

    let expectations = argumentStrings.map("Run Command Line Activity: ".appending).map(XCTestExpectation.init)

    let setOfArgumentLists = argumentStrings.map { Array<String>.init(repeating: $0, count: 1) }
    for (arguments, expectation) in zip(setOfArgumentLists, expectations) {
      let outputStream = RecordedOutputStream()
      let errorStream = RecordedOutputStream()
      let commandLineRunner = CommandLineRunner(outputStream: outputStream, errorStream: errorStream)
      let argumentSet = SpeculidCommandArgumentSet.unknown(arguments)
      let errorString = Application.unknownCommandMessage(fromArguments: arguments)
      let activity = commandLineRunner.activity(withArguments: argumentSet) { activity, error in
        XCTAssertNotNil(activity)
        XCTAssertNotNil(error)
        XCTAssertEqual(
          outputStream.strings,
          [Application.helpText]
        )
        XCTAssertEqual(errorStream.strings, [errorString])
        expectation.fulfill()
      }

      activity.start()
    }

    wait(for: expectations, timeout: 10.0)
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
        [Application.helpText]
      )
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
    let versionProvider = MockVersionProvider()
    let commandLineRunner = CommandLineRunner(outputStream: outputStream, errorStream: errorStream, versionProvider: versionProvider)

    var expectedStrings = [versionProvider.version!.developmentDescription]

    #if DEBUG
      expectedStrings.append(" DEBUG")
    #endif

    let activity = commandLineRunner.activity(withArguments: argument) { activity, error in
      XCTAssertNotNil(activity)
      XCTAssertNil(error)
      XCTAssertEqual(
        outputStream.strings,
        expectedStrings
      )
      XCTAssertEqual(errorStream.strings, [])
      expectation.fulfill()
    }

    activity.start()

    wait(for: [expectation], timeout: 10.0)
  }
}
