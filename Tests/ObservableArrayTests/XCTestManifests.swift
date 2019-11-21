import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(observable_arrayTests.allTests),
    ]
}
#endif
