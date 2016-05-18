
public protocol StructureProtocol {
    var array: [Self]? { get }
    var object: [String: Self]? { get }

    init(arrayStructure: [Self])
    init(objectStructure: [String: Self])
}

//extension Node: StructureProtocol {
////    var array: [StructureProtocol]? {
////        guard case let .array(arr) = self else {
////            return nil
////        }
////        return arr
////    }
////
////    var object: [String: StructureProtocol]? {
////        guard case let .object(ob) = self else {
////            return nil
////        }
////        return ob
////    }
//
//    public init(arrayStructure: [StructureProtocol]) {
//        self = .array(arrayStructure as! [Node])
//    }
//
//    public init(objectStructure: [String: StructureProtocol]) {
//        self = .object(objectStructure as! [String : Node])
//    }
//}

// MARK: Indexable

/**
 Anything that can be used as subscript access for a Node.
 
 Int and String are supported natively, additional Indexable types
 should only be added after very careful consideration.
 */
public protocol NodeIndexable {
    /**
     Acess for 'self' within the given node, 
     ie: inverse ov `= node[self]`

     - parameter node: the node to access

     - returns: a value for index of 'self' if exists
     */
    func access<T: StructureProtocol>(in node: T) -> T?

    /**
     Set given input to a given node for 'self' if possible.
     ie: inverse of `node[0] =`

     - parameter input:  value to set in parent, or `nil` if should remove
     - parameter parent: node to set input in
     */
    func set<T: StructureProtocol>(_ input: T?, to parent: inout T)

    func makeEmptyStructure<T: StructureProtocol>() -> T
}

extension Int: NodeIndexable {
    /**
     - see: NodeIndexable
     */
    public func access<T: StructureProtocol>(in node: T) -> T? {
        guard let array = node.array where self < array.count else { return nil }
        return array[self]
    }

    /**
     - see: NodeIndexable
     */
    public func set<T: StructureProtocol>(_ input: T?, to parent: inout T) {
        guard let array = parent.array where self < array.count else { return }
        var mutable = array
        if let new = input {
            mutable[self] = new
        } else {
            mutable.remove(at: self)
        }
        parent = parent.dynamicType.init(arrayStructure: mutable)
    }

    public func makeEmptyStructure<T: StructureProtocol>() -> T {
        return T(arrayStructure: [])
    }
}

extension String: NodeIndexable {
    /**
     - see: NodeIndexable
     */
    public func access<T: StructureProtocol>(in node: T) -> T? {
        if let object = node.object?[self] {
            return object
        } else if let array = node.array {
            let value = array.flatMap(self.access)
            if value.count == array.count {
                return node.dynamicType.init(arrayStructure: value)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    /**
     - see: NodeIndexable
     */
    public func set<T: StructureProtocol>(_ input: T?, to parent: inout T) {
        if let object = parent.object {
            var mutable = object
            mutable[self] = input
            parent = parent.dynamicType.init(objectStructure: mutable)
        } else if let array = parent.array {
            let mapped: [T] = array.map { val in
                var mutable = val
                self.set(input, to: &mutable)
                return mutable
            }
            parent = parent.dynamicType.init(arrayStructure: mapped)
        }
    }


    public func makeEmptyStructure<T: StructureProtocol>() -> T {
        return T(objectStructure: [:])
    }
}
