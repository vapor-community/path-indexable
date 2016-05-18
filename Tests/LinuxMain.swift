
#if os(Linux)

import XCTest
@testable import NodeIndexableTestSuite

XCTMain([
    testCase(DictionaryKeyPathTests.allTests),
    testCase(NodeIndexableTests.allTests),
])

#endif
