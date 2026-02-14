// test: literal values

func testIntLiterals () -> Unit {
	var a = 0
	var b = 1
	var c = -1
	var d = 42
	var e = 1000000
	var f: Nat8 = 255
	var g: Int64 = -9223372036854775807
}

func testFloatLiterals () -> Unit {
	var a = 0.0
	var b = 3.14
	var c = -2.718
	var e: Float32 = 1.5
	var f: Float64 = 2.5
}

func testBoolLiterals () -> Unit {
	var a = true
	var b = false
}

func testCharLiterals () -> Unit {
	var a = 'A'
	var b = 'z'
	var c = '0'
	var d = ' '
}

func testStringLiterals () -> Unit {
	var a = "hello"
	var b = ""
	var c = "hello world"
	var d = "line1\nline2"
}

func testRecordLiterals () -> Unit {
	var a = {}
	var b = {x = 1}
	var c = {x = 1, y = 2}
	var d = {name = "test", value = 42}
}

func testArrayLiterals () -> Unit {
	var a = [1, 2, 3]
	var b = [true, false, true]
	var c = [1.0, 2.0, 3.0]
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
