@testable import Speculid
import XCTest
import RandomKit

struct SimpleCommandLineArgumentProvider: CommandLineArgumentProviderProtocol {
  public let arguments: [String]
}

class SpeculidApplicationModeParserTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testParseModeHelp() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let arguments = SimpleCommandLineArgumentProvider(arguments: ["-help"])
    let parser = SpeculidApplicationModeParser()
    let actual = parser.parseMode(fromCommandLine: arguments)
    let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.help)
    XCTAssertEqual(actual, expected)
  }

  func testParseModeVersion() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let arguments = SimpleCommandLineArgumentProvider(arguments: ["-version"])
    let parser = SpeculidApplicationModeParser()
    let actual = parser.parseMode(fromCommandLine: arguments)
    let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.version)
    XCTAssertEqual(actual, expected)
  }

  func testParseModeCocoa() {
    let arguments = SimpleCommandLineArgumentProvider(arguments: [])
    let parser = SpeculidApplicationModeParser()
    let actual = parser.parseMode(fromCommandLine: arguments)
    let expected = SpeculidApplicationMode.cocoa
    XCTAssertEqual(actual, expected)
  }

  func testParseModeFile() {
    let argumentSet = Array<String>(randomCount: 100, using: &Xoroshiro.default).map { Array<String>.init(repeating: $0, count: 1) }.map(SimpleCommandLineArgumentProvider.init)
    for arguments in argumentSet {
      let parser = SpeculidApplicationModeParser()
      let actual = parser.parseMode(fromCommandLine: arguments)
      let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.unknown(arguments.arguments))
      XCTAssertEqual(actual, expected)
    }
  }
}
