// tests/lang/value/sizeof/src/main.m

type Point = {x: Int32, y: Int32}
type Packed = @layout("packed") {a: Nat8, b: Nat32}

var sizeInt = sizeof(Int32)
var sizePoint = sizeof(Point)
var sizePacked = sizeof(Packed)

var alignInt = alignof(Int32)
var alignPoint = alignof(Point)

var offX = offsetof(Point.x)
var offY = offsetof(Point.y)

func testSizeof () -> Nat64 {
	var a = sizeof(Int32)
	var b = sizeof(Int64)
	var c = sizeof(Float64)
	var d = sizeof(Point)
	return a + b + c + d
}

func testAlignof () -> Nat64 {
	var a = alignof(Int32)
	var b = alignof(Float64)
	return a + b
}

func testOffsetof () -> Nat64 {
	var a = offsetof(Point.x)
	return Nat64 a
}

func testLengthof () -> Int32 {
	var arr: [5]Int32
	return lengthof(arr)
}

func main () -> Int32 {
	var a = testSizeof()
	var b = testAlignof()
	var c = testOffsetof()
	var d = testLengthof()
	return 0
}
