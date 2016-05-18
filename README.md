<h1 align="center">NodeIndexable</h1>

The purpose of this package is to allow complex key path logic to be applied to multiple types of data structures.

### StructureProtocol

This type is used to define a structure that can inherit complex subscripting.

```Swift
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
```

Any type that conforms to this protocol inherits the following subscript functionality.

### Examples

Standard String

```Swift
let id = json["id"]
```

Standard Int

```Swift
let second = json[1]
```

Multiple Strings

ie:

```
let json = [
  "nested": [
    "key": "value"
  ]
]
```

```
let value = json["nested", "key"] // .string("value")
```

Multiple Ints

```
let json = [
  [0,1,2],
  [3,4,5]
]
```

```
let value = json[1, 2] // 5
```

Mixed

```
let json = [
  ["name" : "joe"]
  ["name" : "jane"]
]
```

```Swift
let value = json[0, "name"] // "joe"
```

Array Keys

```
let json = [
  ["name" : "joe"]
  ["name" : "jane"]
]
```

```Swift
let arrayOfNames = json["name"] // ["joe", "jane"]
```
