# Value Literals

### Numeric literals
Numeric literals have type **GenericNumeric**
```swift
42
```

You can cast it to any real type (Int8, Int16, Int32, Nat8, etc.)

```swift
var a : Int8
a := 42
var b : Int16
b := 42
var c : Int32
c := 42

var e : Nat8
e := 256 // error (Nat8 = {0 .. 255})
```



### String literals
Numeric literals have type **GenericString**
```swift
"Hello wolrd!"
```
You can cast it to:
1) Array
```swift
var array : [12]Nat8 := "Hello wolrd!"
```

2) Pointer to Array
```swift
var ptr_to_array : *[]Nat8 := "Hello wolrd!"
```

String types are aliases to arrays:
```swift
// this types are builtin, and you dont need to describe them
// type Str8 *[]Nat8
// type Str16 *[]Nat16
// type Str32 *[]Nat32
```

And you can use it this way
```swift
var mystr : Str8
mystr := "Hello!"
```
