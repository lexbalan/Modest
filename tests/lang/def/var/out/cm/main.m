private import "builtin"


// typed variables with init
var a: Int32 = 0
var b: Nat64 = 100
var c: Float64 = 1.5
var d: Bool = true
var e: Char8 = "x"

// inferred type
var f: Int32 = 42
var g: Float64 = 3.14
var h: Bool = true
var i: *[]Char8 = "z"
var j: *[]Char8 = "hello"

// uninitialized typed
var k: Int32
var l: Nat8
var m: Float32
var n: Bool


// record variables
//var p = {x = 1, y = 2}
var q: {a: Int32, b: Int32} = {a = 0, b = 0}

// array variables
var arr1: [5]Int32
var arr2: [5]Int32 = [1, 2, 3, 4, 5]

// pointer variables
var ptr: *Int32 = &a

// multiple vars of same type
var x1: Int32 = 0
var x2: Int32 = 1
var x3: Int32 = 2

public func main () -> Int32 {
	return 0
}

