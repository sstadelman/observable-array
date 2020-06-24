#if !os(watchOS)
import XCTest

import ObservableArrayTests

var tests = [XCTestCaseEntry]()
tests += ObservableArrayTests.allTests()
XCTMain(tests)
#endif
