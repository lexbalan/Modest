import "builtin"



func testIntLiterals () -> Unit {
	let a = 0
	let b = 1
	let c = -1
	let d = 42
	let e = 1000000
	let f: Nat8 = 255
	let g: Int64 = -9223372036854775807
}


func testFloatLiterals () -> Unit {
	let a = .0
	let b = 3.14
	let c = -2.718
	let e: Float32 = 1.5
	let f: Float64 = 2.5
}


func testBoolLiterals () -> Unit {
	let a: Bool = true
	let b: Bool = false
}


func testCharLiterals () -> Unit {
	let a = "A"
	let b = "z"
	let c = "0"
	let d = " "
}


func testStringLiterals () -> Unit {
	let a = "hello"
	let b = ""
	let c = "hello world"
	let d = "line1\nline2"
}


func testRecordLiterals () -> Unit {
	let a = {}
	let b = {x = 1}
	let c = {x = 1, y = 2}
	let d = {name = "test", value = 42}
}


func testArrayLiterals () -> Unit {
	let a = [1, 2, 3]
	let b = [true, false, true]
	let c = [1.0, 2.0, 3.0]
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

