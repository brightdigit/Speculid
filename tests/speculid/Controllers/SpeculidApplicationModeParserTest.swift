@testable import Speculid
import XCTest

private let _alphanumericcharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

extension String {
  static func randomAlphanumeric(ofLength length: Int) -> String {
    let randomCharacters = (0 ..< length).map { _ in _alphanumericcharacters.randomElement()! }
    return String(randomCharacters)
  }
}
struct SimpleCommandLineArgumentProvider: CommandLineArgumentProviderProtocol {
  public let arguments: [String]
  public init(arguments: [String]) {
    self.arguments = arguments
  }
  public init(randomWithCount count: Int) {
    arguments = (0 ..< count).map { _ in String.randomAlphanumeric(ofLength: 100) }
  }
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
    let arguments = SimpleCommandLineArgumentProvider(arguments: ["--help"])
    let parser = SpeculidApplicationModeParser()
    let actual = parser.parseMode(fromCommandLine: arguments)
    let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.help)
    XCTAssertEqual(actual, expected)
  }

  func testParseModeVersion() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let arguments = SimpleCommandLineArgumentProvider(arguments: ["--version"])
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
    let fileURL = Bundle(for: type(of: self)).url(forResource: "dummy", withExtension: nil)!
    let arguments = SimpleCommandLineArgumentProvider(arguments: ["--process", fileURL.path])
    let parser = SpeculidApplicationModeParser()
    let actual = parser.parseMode(fromCommandLine: arguments)
    let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.process(fileURL))
    XCTAssertEqual(actual, expected)
  }
}
