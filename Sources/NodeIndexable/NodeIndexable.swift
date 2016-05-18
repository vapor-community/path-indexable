
/**
 Objects wishing to inherit complex subscripting should implement
 this protocol
 */
public protocol StructureProtocol {
    /// If self is an array representation, return array
    var array: [Self]? { get }

    /// If self is an object representation, return object
    var object: [String: Self]? { get }

    /**
     Initialize a new object encapsulating an array of Self

     - parameter array: value to encapsulate
     */
    init(_ array: [Self])

    /**
     Initialize a new object encapsulating an object of type [String: Self]

     - parameter object: value to encapsulate
     */
    init(_ object: [String: Self])
}

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

    /**
     Create an empty structure that can be set with the given type.
     
     ie: 
     - a string will create an empty dictionary to add itself as a value
     - an Int will create an empty array to add itself as a value


     - returns: an empty structure that can be set by Self
     */
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
        parent = parent.dynamicType.init(mutable)
    }

    public func makeEmptyStructure<T: StructureProtocol>() -> T {
        return T([])
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
                return node.dynamicType.init(value)
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
            parent = parent.dynamicType.init(mutable)
        } else if let array = parent.array {
            let mapped: [T] = array.map { val in
                var mutable = val
                self.set(input, to: &mutable)
                return mutable
            }
            parent = parent.dynamicType.init(mapped)
        }
    }


    public func makeEmptyStructure<T: StructureProtocol>() -> T {
        return T([:])
    }
}
