private import "builtin"


type Point = {x: Int32, y: Int32}
type Packed = @layout {a: Nat8, b: Nat32}

var sizeInt: Size = sizeof(Int32)
var sizePoint: Size = sizeof(Point)
var sizePacked: Size = sizeof(Packed)

var alignInt: Size = alignof(Int32)
var alignPoint: Size = alignof(Point)

var offX: Int32 = offsetof(Point.x)
var offY: Int32 = offsetof(Point.y)

func testSizeof () -> Nat64 {
	var a: Size = sizeof(Int32)
	var b: Size = sizeof(Int64)
	var c: Size = sizeof(Float64)
	var d: Size = sizeof(Point)
	return a + b + c + d
}

func testAlignof () -> Nat64 {
	var a: Size = alignof(Int32)
	var b: Size = alignof(Float64)
	return a + b
}

func testOffsetof () -> Nat64 {
	var a: Int32 = offsetof(Point.x)
	return Nat64 a
}

func testLengthof () -> Int32 {
	var arr: [5]Int32
	return lengthof(arr)
}

public func main () -> Int32 {
	var a: Nat64 = testSizeof()
	var b: Nat64 = testAlignof()
	var c: Nat64 = testOffsetof()
	var d: Int32 = testLengthof()
	return 0
}

