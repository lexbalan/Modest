// tests/lang/stmt/assign/src/main.m


var g: Int32 = 0


func testSimple () -> Unit {
	var x: Int32 = 0
	x = 1
	x = 2 + 3
	x = x + 1
}


func testExpandedCompound () -> Unit {
	var x: Int32 = 10
	x = x + 5
	x = x - 3
	x = x * 2
	x = x / 4
	x = x % 3
}


func testIncDec () -> Unit {
	var x: Int32 = 0
	++x
	++x
	--x
}


func testPointerAssign () -> Unit {
	var x: Int32 = 0
	var p = &x
	*p = 42
}


func testRecordAssign () -> Unit {
	var p = {x: Int32, y: Int32} {x = 0, y = 0}
	p.x = 10
	p.y = 20
}


func testArrayAssign () -> Unit {
	var arr: [3]Int32
	arr[0] = 1
	arr[1] = 2
	arr[2] = 3
}


func testGlobalAssign () -> Unit {
	g = 42
}


public func main () -> Int32 {
	testSimple()
	testExpandedCompound()
	testIncDec()
	testPointerAssign()
	testRecordAssign()
	testArrayAssign()
	testGlobalAssign()
	return 0
}


