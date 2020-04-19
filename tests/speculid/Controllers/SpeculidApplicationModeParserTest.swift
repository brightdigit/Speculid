@testable import SpeculidKit
import XCTest

private let _alphanumericcharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

extension String {
    static func randomAlphanumeric(ofLength length: Int) -> String {
        let randomCharacters = (0 ..< length).map { _ in _alphanumericcharacters.randomElement()! }
        return String(randomCharacters)
    }
}

extension Array where Element == String {
    static func randomElements(ofCount count: Int) -> Array {
        (0 ..< count).map { _ in String.randomAlphanumeric(ofLength: 100) }
    }
}

//
// @available(swift, obsoleted: 4.2)
// extension Array {
//  func randomElement() -> Element? {
//    guard count > 0 else {
//      return nil
//    }
//    let index = Index(arc4random_uniform(UInt32(count)))
//    return self[index]
//  }
// }
//
// @available(swift, obsoleted: 4.2)
// extension String {
//  func randomElement() -> Character? {
//    guard count > 0 else {
//      return nil
//    }
//    let offset = Int(arc4random_uniform(UInt32(count)))
//    let index = self.index(startIndex, offsetBy: offset)
//    return self[index]
//  }
// }

struct SimpleCommandLineArgumentProvider: CommandLineArgumentProviderProtocol {
    var environment: [String: String]

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

    func testParseModeUnknownWithExecutable() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let arguments = [String].randomElements(ofCount: 7)
        let provider = SimpleCommandLineArgumentProvider(arguments: [Bundle.main.executablePath!] + arguments)
        let parser = SpeculidApplicationModeParser()
        let actual = parser.parseMode(fromCommandLine: provider)
        let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.unknown(arguments))
        XCTAssertEqual(actual, expected)
    }

    func testParseModeUnknown() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let provider = SimpleCommandLineArgumentProvider(randomWithCount: 7)
        let parser = SpeculidApplicationModeParser()
        let actual = parser.parseMode(fromCommandLine: provider)
        let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.unknown(provider.arguments))
        XCTAssertEqual(actual, expected)
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
        let expected = SpeculidApplicationMode.command(SpeculidCommandArgumentSet.process(fileURL, true))
        XCTAssertEqual(actual, expected)
    }
}
