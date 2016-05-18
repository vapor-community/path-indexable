
#if os(Linux)

import XCTest
@testable import GenomeTestSuite

XCTMain([
    testCase(DictionaryKeyPathTests.allTests),
    testCase(NodeIndexableTests.allTests),
])

#endif
