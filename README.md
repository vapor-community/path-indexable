<h1 align="center">PathIndexable</h1>

The purpose of this package is to allow complex key path logic to be applied to multiple types of data structures.

### PathIndexable

This type is used to define a structure that can inherit complex subscripting.

```Swift
public protocol PathIndexable {
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


## 🌏 Environment

|Polymorphic|Xcode|Swift|
|:-:|:-:|:-:|
|0.3.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-20-qutheory|
|0.2.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-05-03-a|
|0.1.x|7.3.x|DEVELOPMENT-SNAPSHOT-2016-05-03-a|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.qutheory.io) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](slack.qutheory.io) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.
