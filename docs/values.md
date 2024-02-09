# Values

## Literal values

### Numeric literals
Numeric literals have type **PerfectNumeric**
```swift
42
```

You can cast it to any imperfect type (Int8, Int16, Int32, Nat8, etc.)

```swift
var a : Int8
a = 42
var b : Int16
b = 42
var c : Int32
c = 42

var e : Nat8
e = 256 // error (Nat8 = {0 .. 255})
```



### String literals
String literals have type `[]PerfectChar`
```swift
"Hello wolrd!"
```
You can cons from it:
1) Array of Char
```swift
var array : [12]Char8 = "Hello wolrd!"
```

2) Pointer to Array of Char
```swift
var ptr_to_array : *[]Char8 = "Hello wolrd!"
```



And you can use it this way
```swift
var mystr : *Str8
mystr = "Hello!"
```
