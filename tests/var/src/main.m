// tests/var/src/main.m
//
// var definitions and statements: typed/inferred forms, multi-variable
// groups, zero-init (global) vs. must-assign-before-use (local),
// @immutable, and the lvalue forms assignment supports
// (see docs/lang/def/var.md, docs/lang/stmt/var.md, docs/lang/stmt/assign.md).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



type Point = {x: Int32, y: Int32}



// a global var without an initializer is zero-initialized
var globalZeroInt: Int32
var globalZeroArr: [4]Int32
var globalZeroPoint: Point

// multiple globals of one type, all zero-initialized
var r, g, b: Nat8

// a global var with an initializer
var globalCounter: Int32 = 7

@immutable var immutableGlobal: Int32 = 42



public func testGlobalZeroInit () -> Bool {
	if globalZeroInt != 0 {
		printf("error: globalZeroInt != 0\n")
		return false
	}
	if globalZeroArr[0] != 0 or globalZeroArr[3] != 0 {
		printf("error: globalZeroArr not all zero\n")
		return false
	}
	if globalZeroPoint.x != 0 or globalZeroPoint.y != 0 {
		printf("error: globalZeroPoint not all zero\n")
		return false
	}
	if r != 0 or g != 0 or b != 0 {
		printf("error: r/g/b not all zero\n")
		return false
	}
	if globalCounter != 7 {
		printf("error: globalCounter != 7\n")
		return false
	}

	printf("passed: global zero-init test\n")
	return true
}



public func testImmutableGlobal () -> Bool {
	if immutableGlobal != 42 {
		printf("error: immutableGlobal != 42\n")
		return false
	}

	printf("passed: immutable global test\n")
	return true
}



// typed local vars: explicit type, initializer implicitly constructed to it
public func testTypedLocalVar () -> Bool {
	var a: Int32 = 0
	var n: Nat64 = 100
	var f: Float64 = 1.5
	var flag: Bool = true
	var c: Char8 = 'x'

	if a != 0 or n != Nat64 100 or f != 1.5 or not flag or c != Char8 'x' {
		printf("error: typed local var mismatch\n")
		return false
	}

	printf("passed: typed local var test\n")
	return true
}



// inferred local vars: generic literals take the target default type
public func testInferredLocalVar () -> Bool {
	var i = 10          // Integer -> Int
	var p = 3.14         // Rational -> Float
	var flag = true
	var s = "hello"      // String -> Str8

	if i != 10 or p != 3.14 or not flag {
		printf("error: inferred local var mismatch\n")
		return false
	}
	if s[0] != Char8 'h' or s[4] != Char8 'o' {
		printf("error: inferred string var mismatch\n")
		return false
	}

	printf("passed: inferred local var test\n")
	return true
}



// several variables of one type, declared together
public func testMultiLocalDecl () -> Bool {
	var x1, x2, x3: Int32

	x1 = 1
	x2 = 2
	x3 = 3

	if x1 != 1 or x2 != 2 or x3 != 3 {
		printf("error: multi local decl mismatch\n")
		return false
	}

	printf("passed: multi local decl test\n")
	return true
}



// a local var without an initializer must be assigned before first use;
// explicit zeroing spells out the zero value instead
public func testExplicitZeroInit () -> Bool {
	var local: Int32           // unusable until assigned
	local = 5
	if local != 5 {
		printf("error: local != 5\n")
		return false
	}

	var zeroArr: [4]Int32 = []
	if zeroArr[0] != 0 or zeroArr[3] != 0 {
		printf("error: zeroArr not all zero\n")
		return false
	}

	var zeroPoint: Point = {}
	if zeroPoint.x != 0 or zeroPoint.y != 0 {
		printf("error: zeroPoint not all zero\n")
		return false
	}

	printf("passed: explicit zero-init test\n")
	return true
}



public func testLocalImmutable () -> Bool {
	@immutable var maxItems: Int32 = 100

	if maxItems != 100 {
		printf("error: maxItems != 100\n")
		return false
	}

	printf("passed: local immutable test\n")
	return true
}



public func testVarArray () -> Bool {
	var arr: [5]Int32 = [1, 2, 3, 4, 5]

	if arr[0] != 1 or arr[4] != 5 {
		printf("error: arr element mismatch\n")
		return false
	}

	var mid = arr[1:4]          // sub-array [2, 3, 4]
	if mid != [2, 3, 4] {
		printf("error: mid != [2, 3, 4]\n")
		return false
	}

	arr[0] = 9
	if arr[0] != 9 {
		printf("error: arr[0] != 9 after assignment\n")
		return false
	}

	printf("passed: var array test\n")
	return true
}



public func testVarRecord () -> Bool {
	var p: Point = {x = 1, y = 2}

	if p.x != 1 or p.y != 2 {
		printf("error: p.x/p.y mismatch\n")
		return false
	}

	p.x = 10
	if p.x != 10 {
		printf("error: p.x != 10 after assignment\n")
		return false
	}

	var pp: *Point = &p
	pp.y = 20                  // auto-deref field write through pointer
	if p.y != 20 {
		printf("error: p.y != 20 after pointer field assignment\n")
		return false
	}

	printf("passed: var record test\n")
	return true
}



public func testVarPointer () -> Bool {
	var x: Int32 = 1
	var ptr: *Int32 = &x

	if *ptr != 1 {
		printf("error: *ptr != 1\n")
		return false
	}

	*ptr = 100
	if x != 100 {
		printf("error: x != 100 after pointer write\n")
		return false
	}

	printf("passed: var pointer test\n")
	return true
}



public func testIncrementDecrement () -> Bool {
	var i: Nat32 = 0
	var j: Nat32 = 5

	++i
	++i
	--j

	if i != 2 or j != 4 {
		printf("error: increment/decrement mismatch\n")
		return false
	}

	printf("passed: increment/decrement test\n")
	return true
}



func main () -> Int {
	printf("test var\n")

	var result = true
	result = testGlobalZeroInit() and result
	result = testImmutableGlobal() and result
	result = testTypedLocalVar() and result
	result = testInferredLocalVar() and result
	result = testMultiLocalDecl() and result
	result = testExplicitZeroInit() and result
	result = testLocalImmutable() and result
	result = testVarArray() and result
	result = testVarRecord() and result
	result = testVarPointer() and result
	result = testIncrementDecrement() and result

	printf("test ")
	if not result {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}
