// tests/lang/value/cons/src/main.m

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

public func main () -> Int32 {
	var a = testIntToFloat()
	var b = testFloatToInt()
	var c = testWidenInt()
	var d = testNatToInt()
	var e = testIntToNat()
	var f = testWidenNat()
	var g = testFloatWiden()
	return 0
}
