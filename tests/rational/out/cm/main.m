import "builtin"
include "stdio"
include "stdlib"

include "libc/stdio"
include "libc/stdlib"


// module-level Rational consts: dyadic values (halves, quarters,
// eighths) are exactly representable in binary floating point, so
// equality comparisons against them are exact regardless of backend
const half = 0.5
const quarter = 0.25
const eighth = 0.125

const pi = 3.14159
const negPi = -3.75


// a Rational const keeps its generic type and adapts independently at
// each use site, same as a generic Integer const does (see
// docs/lang/type/generic.md)
public func testGenericAdaptation () -> Bool {
	var asFloat32: Float32 = half
	var asFloat64: Float64 = half

	if asFloat32 != half {
		printf("error: asFloat32 != 0.5\n")
		return false
	}
	if asFloat64 != half {
		printf("error: asFloat64 != 0.5\n")
		return false
	}

	printf("passed: generic adaptation test\n")
	return true
}



// constant expressions over Rational values fold at compile time and
// stay exact: no float rounding happens between the literals and the
// folded result
const sum = 1.5 + 2.25// 3.75 — magnitude >= 1 (BUGS.md #10-adjacent
// overflow regression: this used to be a
// compile-time "integer overflow" error)
const diff = 5.5 - 1.25// 4.25
const prod = 1.5 * 2.0// 3.0
const quot = 7.0 / 4.0// 1.75
const negated = -sum// -3.75
const just = +1.5// 1.5 (unary + is a no-op, but still a constant expression)

public func testConstFolding () -> Bool {
	if sum != 3.75 {
		printf("error: sum != 3.75\n")
		return false
	}
	if diff != 4.25 {
		printf("error: diff != 4.25\n")
		return false
	}
	if prod != 3.0 {
		printf("error: prod != 3.0\n")
		return false
	}
	if quot != 1.75 {
		printf("error: quot != 1.75\n")
		return false
	}
	if negated != -3.75 {
		printf("error: negated != -3.75\n")
		return false
	}
	let chained = (half + quarter) + eighth
	if chained != 0.875 {
		printf("error: chained != 0.875\n")
		return false
	}

	printf("passed: const folding test\n")
	return true
}



// explicit construction to IntX/NatX truncates the fraction toward zero
// (docs/lang/value/cons.md: "FloatY -> IntX/NatX truncates the fraction")
public func testTruncatingConstruction () -> Bool {
	var truncPos = Int32 pi
	if truncPos != 3 {
		printf("error: Int32 pi != 3 (got %d)\n", truncPos)
		return false
	}

	var truncNeg = Int32 negPi
	if truncNeg != -3 {
		printf("error: Int32 negPi != -3 (got %d)\n", truncNeg)
		return false
	}

	var truncSmall = Int8 negPi
	if truncSmall != -3 {
		printf("error: Int8 negPi != -3\n")
		return false
	}

	var truncNat = Nat32 pi
	if truncNat != 3 {
		printf("error: Nat32 pi != 3 (got %d)\n", truncNat)
		return false
	}

	printf("passed: truncating construction test\n")
	return true
}



// Rational adapts to FloatX at the use site; ordering and equality then
// compare the concrete FloatX values (docs/lang/value/binary.md lists
// Ordering operands as IntX/NatX/FloatX)
public func testFloatComparison () -> Bool {
	var f64: Float64 = pi
	var f32: Float32 = pi

	if f64 <= 3.0 {
		printf("error: f64 <= 3.0\n")
		return false
	}
	if not (f64 < 3.2) {
		printf("error: not (f64 < 3.2)\n")
		return false
	}
	if not (f64 >= pi) {
		printf("error: not (f64 >= pi)\n")
		return false
	}
	if f64 != pi {
		printf("error: f64 != pi\n")
		return false
	}
	if f32 != Float32 pi {
		printf("error: f32 != Float32 pi\n")
		return false
	}

	printf("passed: float comparison test\n")
	return true
}



// const is also allowed inside a function body, same as for Integer
// (see tests/const)
public func testLocalRationalConst () -> Bool {
	let localHalf = 0.5
	let localSum = localHalf + 0.25

	if localSum != 0.75 {
		printf("error: localSum != 0.75\n")
		return false
	}

	var asFloat: Float64 = localSum
	if asFloat != 0.75 {
		printf("error: asFloat != 0.75\n")
		return false
	}

	printf("passed: local rational const test\n")
	return true
}



@nonstatic
func main () -> Int {
	printf("test rational\n")

	var result: Bool = true
	result = testGenericAdaptation() and result
	result = testConstFolding() and result
	result = testTruncatingConstruction() and result
	result = testFloatComparison() and result
	result = testLocalRationalConst() and result

	printf("test ")
	if not result {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

