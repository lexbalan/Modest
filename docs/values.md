# Values

## Literal values

### Numeric literals
Numeric literals have type **GenericNumeric**
```swift
42
```

You can cast it to any non-generic type (Int8, Int16, Int32, Nat8, etc.)

```swift
var a: Int8
a = 42
var b: Int16
b = 42
var c: Int32
c = 42

var e: Nat8
e = 256 // error (Nat8 = {0 .. 255})
```

### Bool literals

```swift
true, false
```


### Array literals
```swift
    // Array of five GenericInt values
    [1, 2, 3, 4, 5]
    
    // Array of tree Int32 values
    [1 to Int32, 2 to Int32, 3 to Int32]
```



#### String literals
String literal is a subkind of array literal and have type `Generic([]GenericChar)` (GenericArray of GenericChar)
```swift
"Hello wolrd!"
```
You can cons from it:
1) Array of Char
```swift
var array: [12]Char8 = "Hello wolrd!"
```

2) Pointer to Array of Char
```swift
var ptr_to_array: *[]Char8 = "Hello wolrd!"
```



### Record literals
```swift
    // Record with two fields
    // 'x' with type GenericInt and value 10
    // 'y' with type GenericInt and value 20
    {x = 10, y = 20}
```


## Value expressions

### Binary value expressions
### Unary value expressions
### Special value expressions


