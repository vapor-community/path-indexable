//
//  BasicTypes.swift
//  Genome
//
//  Created by Logan Wright on 9/19/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import XCTest
@testable import PathIndexable

public enum Node {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([Node])
    case object([String:Node])
}

extension Node: PathIndexable {
    public var pathIndexableArray: [Node]? {
        guard case let .array(arr) = self else {
            return nil
        }
        return arr
    }

    public var pathIndexableObject: [String: Node]? {
        guard case let .object(ob) = self else {
            return nil
        }
        return ob
    }

    public init(_ array: [Node]) {
        self = .array(array)
    }

    public init(_ object: [String : Node]) {
        self = .object(object)
    }
}

class PathIndexableTests: XCTestCase {
    static var allTests: [(String, (PathIndexableTests) -> () throws -> Void)] {
        return [
                   ("testInt", testInt),
                   ("testString", testString),
                   ("testStringSequenceObject", testStringSequenceObject),
                   ("testStringSequenceArray", testStringSequenceArray),
                   ("testIntSequence", testIntSequence),
                   ("testMixed", testMixed),
        ]
    }

    func testInt() {
        let array: Node = .array(["one",
                                  "two",
                                  "three"].map(Node.string))
        guard let node = array[1] else {
            XCTFail()
            return
        }
        guard case let .string(val) = node else {
            XCTFail()
            return
        }

        XCTAssert(val == "two")
    }

    func testString() {
        let object = Node(["a" : .number(1)])
        guard let node = object["a"] else {
            XCTFail()
            return
        }
        guard case let .number(val) = node else {
            XCTFail()
            return
        }

        XCTAssert(val == 1)
    }

    func testStringSequenceObject() {
        let sub = Node(["path" : .string("found me!")])
        let ob = Node(["key" : sub])
        guard let node = ob["key", "path"] else {
            XCTFail()
            return
        }
        guard case let .string(val) = node else {
            XCTFail()
            return
        }
        
        XCTAssert(val == "found me!")
    }

    func testStringSequenceArray() {
        let zero = Node(["a" : .number(0)])
        let one = Node(["a" : .number(1)])
        let two = Node(["a" : .number(2)])
        let three = Node(["a" : .number(3)])
        let obArray = Node([zero, one, two, three])

        guard let collection = obArray["a"] else {
            XCTFail()
            return
        }
        guard case let .array(value) = collection else {
            XCTFail()
            return
        }

        let mapped: [Double] = value.flatMap { node in
            guard case let .number(val) = node else {
                return nil
            }
            return val
        }
        XCTAssert(mapped == [0,1,2,3])
    }

    func testIntSequence() {
        let inner = Node([.string("..."),
                          .string("found me!")])
        let outer = Node([inner])

        guard let node = outer[0, 1] else {
            XCTFail()
            return
        }
        guard case let .string(value) = node else {
            XCTFail()
            return
        }

        XCTAssert(value == "found me!")
    }

    func testMixed() {
        let array = Node([.string("a"), .string("b"), .string("c")])
        let mixed = Node(["one" : array])

        guard let node = mixed["one", 1] else {
            XCTFail()
            return
        }
        guard case let .string(value) = node else {
            XCTFail()
            return
        }

        XCTAssert(value == "b")
    }
}
