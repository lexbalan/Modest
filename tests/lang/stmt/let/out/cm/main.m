import "builtin"


func testLetInt () -> Int32 {
	let x = 42
	return x
}

func testLetFloat () -> Float64 {
	let pi = 3.14159
	return pi
}

func testLetBool () -> Bool {
	let flag: Bool = true
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
	let sum: Int32 = a + b
	let product: Int32 = a * b
	let result: Int32 = sum + product
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
	var a: Int32 = testLetInt()
	var b: Float64 = testLetFloat()
	var c: Bool = testLetBool()
	var d: *Str8 = testLetStr()
	var e: Int32 = testLetRecord()
	var f: Int32 = testLetExpr(3, 4)
	var g: Int32 = testLetMultiple()
	return 0
}

