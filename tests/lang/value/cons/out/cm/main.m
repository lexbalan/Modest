private import "builtin"


func testIntToFloat () -> Float64 {
	var x: Int32 = 42
	return Float64 x
}

func testFloatToInt () -> Int32 {
	var x: Float64 = 3.14
	return Int32 x
}

func testWidenInt () -> Int64 {
	var x: Int32 = 100
	return Int64 x
}

func testNatToInt () -> Int32 {
	var x: Nat32 = 100
	return Int32 x
}

func testIntToNat () -> Nat32 {
	var x: Int32 = 100
	return Nat32 x
}

func testWidenNat () -> Nat64 {
	var x: Nat32 = 100
	return Nat64 x
}

func testFloatWiden () -> Float64 {
	var x: Float32 = 1.5
	return Float64 x
}

func main () -> Int32 {
	var a: Float64 = testIntToFloat()
	var b: Int32 = testFloatToInt()
	var c: Int64 = testWidenInt()
	var d: Int32 = testNatToInt()
	var e: Nat32 = testIntToNat()
	var f: Nat64 = testWidenNat()
	var g: Float64 = testFloatWiden()
	return 0
}

