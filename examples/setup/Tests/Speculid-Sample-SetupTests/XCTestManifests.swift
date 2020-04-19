import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Speculid_Sample_SetupTests.allTests),
    ]
}
#endif
