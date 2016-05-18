
#if os(Linux)

import XCTest
@testable import PathIndexableTestSuite

XCTMain([
    testCase(DictionaryKeyPathTests.allTests),
    testCase(PathIndexableTests.allTests),
])

#endif
