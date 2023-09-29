# Value Literals

### Numeric literals
Numeric literals have type **GenericNumeric**
```
    42
```

You can cast it to any real type (Int8, Int16, Int32, Nat8, etc.)

```
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
```
    "Hello wolrd!"
```
You can cast it to:
1) Array
```
var array : [12]Nat8 := "Hello wolrd!"
```

2) Pointer to Array
```
var ptr_to_array : *[]Nat8 := "Hello wolrd!"
```

String types are aliases to arrays:
```
// this types are builtin, and you dont need to describe them
// type Str8 *[]Nat8
// type Str16 *[]Nat16
// type Str32 *[]Nat32
```

And you can use it this way
```
var mystr : Str8
mystr := "Hello!"
```
