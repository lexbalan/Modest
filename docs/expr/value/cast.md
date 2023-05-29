# Cast value expression

## Implicit type casting

Implicit in case:
 - GenericInt -> Int
 - GenericArray -> Array
 - GenericRecord -> Record
 - Pointer to sized array -> pointer to unsized array

```golang
// implicit cast examples

var i : Int32
i := 1  // implicit cast literal numeric value 1 with type GenericInt to type Int32 

var a : [3]Int32

// implicit cast literal array value [1, 2, 3] with type Generic[3]GenericInt to type [3]Int32
a = [1, 2, 3]

var pa : *[]Int32

// implicit cast *[3]Int32 to *[]Int32
pa := &a


var r : record {x : Int32, y : Int32}

// implicit cast literal record value {x=0, y=0} with type GenericRecord {x : Int32, y : Int32}
// to type record {x : Int32, y : Int32}
r := {x=0, y=0}



```


## Explicit type casting

```golang
// explicit cast examples

var i : Int32
var j : Int64
i := j to Int32


let b = [1, 2, 3] to [3]Int
```
