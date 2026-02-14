

func testIntLiterals () -> Unit {
	var a: Int32 = 0
	var b: Int32 = 1
	var c: Int32 = -1
	var d: Int32 = 42
	var e: Int32 = 1000000
	var f: Nat8 = 255
	var g: Int64 = -9223372036854775807
}

func testFloatLiterals () -> Unit {
	var a: Float64 = .0
	var b: Float64 = 3.14
	var c: Float64 = -2.718
	var e: Float32 = 1.5
	var f: Float64 = 2.5
}

func testBoolLiterals () -> Unit {
	var a: Bool = true
	var b: Bool = false
}

func testCharLiterals () -> Unit {
	var a: *[]Char8 = "A"
	var b: *[]Char8 = "z"
	var c: *[]Char8 = "0"
	var d: *[]Char8 = " "
}

func testStringLiterals () -> Unit {
	var a: *[]Char8 = "hello"
	var b: *[]Char8 = ""
	var c: *[]Char8 = "hello world"
	var d: *[]Char8 = "line1\nline2"
}

func testRecordLiterals () -> Unit {
	var a = {}
	var b = {x = 1}
	var c = {x = 1, y = 2}
	var d = {name = "test", value = 42}
}

func testArrayLiterals () -> Unit {
	var a: [3]Int32 = [1, 2, 3]
	var b: [3]Bool = [true, false, true]
	var c: [3]Float64 = [1.0, 2.0, 3.0]
}

public func main () -> Int32 {
	testIntLiterals()
	testFloatLiterals()
	testBoolLiterals()
	testCharLiterals()
	testStringLiterals()
	testRecordLiterals()
	testArrayLiterals()
	return 0
}

