// test: let bindings (immutable locals)

func testLetInt () -> Int32 {
	let x = 42
	return x
}

func testLetFloat () -> Float64 {
	let pi = 3.14159
	return pi
}

func testLetBool () -> Bool {
	let flag = true
	return flag
}

func testLetStr () -> *Str8 {
	let msg = "hello"
	return msg
}

func testLetRecord () -> Int32 {
	let p = {x = 10, y = 20}
	return p.x
}

func testLetExpr (a: Int32, b: Int32) -> Int32 {
	let sum = a + b
	let product = a * b
	let result = sum + product
	return result
}

func testLetMultiple () -> Int32 {
	let a = 1
	let b = 2
	let c = 3
	let d = a + b + c
	return d
}

public func main () -> Int32 {
	var a = testLetInt()
	var b = testLetFloat()
	var c = testLetBool()
	var d = testLetStr()
	var e = testLetRecord()
	var f = testLetExpr(3, 4)
	var g = testLetMultiple()
	return 0
}
