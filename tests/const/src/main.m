// tests/const/src/main.m
//
// const definitions: generic-type retention, compile-time folding,
// typed construction at definition, array/record adaptation and the
// branded-enum idiom (see docs/lang/def/const.md, docs/lang/type/generic.md).

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"



type Point = {x: Int32, y: Int32}
type Point3D = {x: Int32, y: Int32, z: Int32}
type Rect = {topLeft: Point, bottomRight: Point}
type Poly3 = {verts: [3]Point, count: Int32}

type Color = @branded Nat8
const colorRed   = Color 0
const colorGreen = Color 1
const colorBlue  = Color 2



// an untyped const keeps the generic type of its initializer and adapts
// to whatever concrete type each use site needs
const answer = 42

public func testGenericAdaptation () -> Bool {
	var asInt8: Int8 = answer
	var asInt32: Int32 = answer
	var asNat64: Nat64 = answer
	var asFloat64: Float64 = answer
	var asWord16: Word16 = Word16 answer

	if asInt8 != Int8 42 {
		printf("error: asInt8 != 42\n")
		return false
	}
	if asInt32 != 42 {
		printf("error: asInt32 != 42\n")
		return false
	}
	if asNat64 != Nat64 42 {
		printf("error: asNat64 != 42\n")
		return false
	}
	if asFloat64 != 42.0 {
		printf("error: asFloat64 != 42.0\n")
		return false
	}
	if asWord16 != Word16 42 {
		printf("error: asWord16 != 42\n")
		return false
	}

	printf("passed: generic adaptation test\n")
	return true
}



// constant expressions fold at compile time and stay generic
const one = 1
const two = one + 1
const combined = two * two + one
const big = 1_000_000
const hexVal = 0x2A
const negated = -hexVal

public func testConstFolding () -> Bool {
	if two != 2 {
		printf("error: two != 2\n")
		return false
	}
	if combined != 5 {
		printf("error: combined != 5\n")
		return false
	}
	if big != 1000000 {
		printf("error: big != 1000000\n")
		return false
	}
	if hexVal != 42 {
		printf("error: hexVal != 42\n")
		return false
	}
	if negated != -42 {
		printf("error: negated != -42\n")
		return false
	}

	printf("passed: const folding test\n")
	return true
}



// a type annotation on a const constructs the value at the definition site
const typedNat: Nat32 = 100
const typedInt: Int8 = -100
const typedFloat: Float64 = 3.5
const typedFromGeneric: Int64 = one

public func testTypedConst () -> Bool {
	if typedNat != Nat32 100 {
		printf("error: typedNat != 100\n")
		return false
	}
	if typedInt != Int8 -100 {
		printf("error: typedInt != -100\n")
		return false
	}
	if typedFloat != 3.5 {
		printf("error: typedFloat != 3.5\n")
		return false
	}
	if typedFromGeneric != Int64 1 {
		printf("error: typedFromGeneric != 1\n")
		return false
	}

	printf("passed: typed const test\n")
	return true
}



const greeting = "Hi\n"
const ch = "A"

public func testStringAndCharConst () -> Bool {
	var fixed: [3]Char8 = greeting
	if lengthof(fixed) != 3 {
		printf("error: lengthof(greeting) != 3\n")
		return false
	}
	if fixed[0] != Char8 "H" or fixed[1] != Char8 "i" {
		printf("error: greeting chars mismatch\n")
		return false
	}

	var g: *Str8 = greeting
	if g[0] != Char8 "H" {
		printf("error: greeting[0] != 'H'\n")
		return false
	}

	var c: Char8 = ch
	if c != Char8 "A" {
		printf("error: ch != 'A'\n")
		return false
	}

	printf("passed: string/char const test\n")
	return true
}



// a generic array const converts implicitly at equal length, and via
// explicit construction to a longer array with the tail zero-filled
const nums = [1, 2, 3]

public func testArrayConst () -> Bool {
	var same: [3]Int32 = nums
	if same != [1, 2, 3] {
		printf("error: same != [1, 2, 3]\n")
		return false
	}

	var longer: [5]Int32 = [5]Int32 nums
	if longer[0] != 1 or longer[1] != 2 or longer[2] != 3 {
		printf("error: longer head mismatch\n")
		return false
	}
	if longer[3] != 0 or longer[4] != 0 {
		printf("error: longer tail not zero-filled\n")
		return false
	}

	printf("passed: array const test\n")
	return true
}



// a generic record const converts to any record with the same fields;
// construction to a record with extra fields zero-fills them
const point2d = {x = 1, y = 2}

public func testRecordConst () -> Bool {
	var p: Point = point2d
	if p.x != 1 or p.y != 2 {
		printf("error: p.x/p.y mismatch\n")
		return false
	}

	var p3: Point3D = Point3D point2d
	if p3.x != 1 or p3.y != 2 {
		printf("error: p3.x/p3.y mismatch\n")
		return false
	}
	if p3.z != 0 {
		printf("error: p3.z not zero-filled\n")
		return false
	}

	printf("passed: record const test\n")
	return true
}



// records nest: a generic record field adapts recursively to the
// concrete field type, including recursive zero-fill on omitted fields
const rectConst = {topLeft = {x = 0, y = 0}, bottomRight = {x = 10, y = 20}}
const rectPartial = {topLeft = {x = 1, y = 1}}
const rectZero: Rect = {}

public func testNestedRecordConst () -> Bool {
	var r: Rect = rectConst
	if r.topLeft.x != 0 or r.topLeft.y != 0 or r.bottomRight.x != 10 or r.bottomRight.y != 20 {
		printf("error: rectConst mismatch\n")
		return false
	}

	var rp: Rect = rectPartial
	if rp.topLeft.x != 1 or rp.topLeft.y != 1 {
		printf("error: rectPartial.topLeft mismatch\n")
		return false
	}
	if rp.bottomRight.x != 0 or rp.bottomRight.y != 0 {
		printf("error: rectPartial.bottomRight not zero-filled\n")
		return false
	}

	// a doubly-nested field also zero-fills correctly and can be read
	// directly off the immediate constant, no intermediate var needed
	if rectZero.topLeft.x != 0 or rectZero.topLeft.y != 0 or rectZero.bottomRight.x != 0 or rectZero.bottomRight.y != 0 {
		printf("error: rectZero not all zero\n")
		return false
	}

	printf("passed: nested record const test\n")
	return true
}



// arrays nest too: a generic array of generic arrays adapts to a fixed
// matrix type, with whole missing rows zero-filled
const matrix = [[1, 2, 3], [4, 5, 6]]

public func testNestedArrayConst () -> Bool {
	var m: [2][3]Int32 = matrix
	if m[0][0] != 1 or m[0][2] != 3 or m[1][0] != 4 or m[1][2] != 6 {
		printf("error: matrix mismatch\n")
		return false
	}

	var wider: [3][3]Int32 = [3][3]Int32 matrix
	if wider[0] != [1, 2, 3] or wider[1] != [4, 5, 6] {
		printf("error: wider head mismatch\n")
		return false
	}
	// KNOWN BUG: comparing an array value against an all-zero array literal
	// (`wider[2] != [0, 0, 0]`) crashes the LLVM backend — the zero literal
	// lowers straight to a `zeroinitializer` constant, and the equality
	// codegen bitcasts it to i8* for memcmp without ever storing it to an
	// addressable alloca first ("invalid cast opcode for cast from
	// '[3 x i32]' to 'ptr'"). Elementwise comparison avoids the codegen
	// path entirely.
	if wider[2][0] != 0 or wider[2][1] != 0 or wider[2][2] != 0 {
		printf("error: wider extra row not zero-filled\n")
		return false
	}

	var mz: [2][3]Int32 = []
	if mz[0][0] != 0 or mz[0][1] != 0 or mz[0][2] != 0 {
		printf("error: mz row 0 not all zero\n")
		return false
	}
	if mz[1][0] != 0 or mz[1][1] != 0 or mz[1][2] != 0 {
		printf("error: mz row 1 not all zero\n")
		return false
	}

	printf("passed: nested array const test\n")
	return true
}



// an array of records: each element adapts independently, including
// zero-filled record elements in the tail of a longer array
const points = [{x = 1, y = 1}, {x = 2, y = 2}, {x = 3, y = 3}]

public func testArrayOfRecordsConst () -> Bool {
	var arr: [3]Point = points
	if arr[0].x != 1 or arr[0].y != 1 or arr[2].x != 3 or arr[2].y != 3 {
		printf("error: points mismatch\n")
		return false
	}

	var longer: [5]Point = [5]Point points
	if longer[2].x != 3 or longer[2].y != 3 {
		printf("error: longer head mismatch\n")
		return false
	}
	if longer[3].x != 0 or longer[3].y != 0 or longer[4].x != 0 or longer[4].y != 0 {
		printf("error: longer tail records not zero-filled\n")
		return false
	}

	printf("passed: array of records const test\n")
	return true
}



// a record with an array field: the field adapts as a nested array,
// zero-filled (element by element) when the whole field is omitted
const triangle = {verts = [{x = 0, y = 0}, {x = 1, y = 0}, {x = 0, y = 1}], count = 3}
const polyPartial = {count = 1}

public func testRecordWithArrayFieldConst () -> Bool {
	var poly: Poly3 = triangle
	if poly.count != 3 {
		printf("error: triangle.count mismatch\n")
		return false
	}
	if poly.verts[0].x != 0 or poly.verts[1].x != 1 or poly.verts[2].y != 1 {
		printf("error: triangle.verts mismatch\n")
		return false
	}

	var polyP: Poly3 = polyPartial
	if polyP.count != 1 {
		printf("error: polyPartial.count mismatch\n")
		return false
	}
	if polyP.verts[0].x != 0 or polyP.verts[1].y != 0 or polyP.verts[2].x != 0 {
		printf("error: polyPartial.verts not zero-filled\n")
		return false
	}

	printf("passed: record with array field const test\n")
	return true
}



// a typed const with an empty literal zero-fills the whole value
const zeroArr: [4]Int32 = []
const zeroPoint: Point = {}
const zeroPoints: [3]Point = []
const zeroMatrix: [2][3]Int32 = []

public func testEmptyLiteralConst () -> Bool {
	// scalar array from []: element access works directly on the const
	if zeroArr[0] != 0 or zeroArr[1] != 0 or zeroArr[2] != 0 or zeroArr[3] != 0 {
		printf("error: zeroArr not all zero\n")
		return false
	}

	// record from {}: field access works directly on the const
	if zeroPoint.x != 0 or zeroPoint.y != 0 {
		printf("error: zeroPoint not all zero\n")
		return false
	}

	// nested array (matrix) from []: index-then-index also works directly
	// on the const — no record field lookup is involved
	if zeroMatrix[0][0] != 0 or zeroMatrix[0][2] != 0 or zeroMatrix[1][0] != 0 or zeroMatrix[1][2] != 0 {
		printf("error: zeroMatrix not all zero\n")
		return false
	}

	// array of records from []: index-then-field-access also works directly
	// on the const
	if zeroPoints[0].x != 0 or zeroPoints[0].y != 0 or zeroPoints[1].x != 0 or zeroPoints[1].y != 0 or zeroPoints[2].x != 0 or zeroPoints[2].y != 0 {
		printf("error: zeroPoints not all zero\n")
		return false
	}

	printf("passed: empty literal const test\n")
	return true
}



// enum idiom: branded type + module-level consts
public func testBrandedEnumConst () -> Bool {
	if colorRed == colorGreen {
		printf("error: colorRed == colorGreen\n")
		return false
	}
	if colorGreen == colorBlue {
		printf("error: colorGreen == colorBlue\n")
		return false
	}
	if colorRed != colorRed {
		printf("error: colorRed != colorRed\n")
		return false
	}
	if Nat8 colorGreen != 1 {
		printf("error: Nat8 colorGreen != 1\n")
		return false
	}

	printf("passed: branded enum const test\n")
	return true
}



// const is also allowed inside a function body
public func testLocalConst () -> Bool {
	const localOne = 1
	const localTwo: Int32 = localOne + 1

	if localTwo != 2 {
		printf("error: localTwo != 2\n")
		return false
	}

	var asFloat: Float64 = localOne
	if asFloat != 1.0 {
		printf("error: asFloat != 1.0\n")
		return false
	}

	printf("passed: local const test\n")
	return true
}



func main () -> Int {
	printf("test const\n")

	var result = true
	result = testGenericAdaptation() and result
	result = testConstFolding() and result
	result = testTypedConst() and result
	result = testStringAndCharConst() and result
	result = testArrayConst() and result
	result = testRecordConst() and result
	result = testNestedRecordConst() and result
	result = testNestedArrayConst() and result
	result = testArrayOfRecordsConst() and result
	result = testRecordWithArrayFieldConst() and result
	result = testEmptyLiteralConst() and result
	result = testBrandedEnumConst() and result
	result = testLocalConst() and result

	printf("test ")
	if not result {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}
