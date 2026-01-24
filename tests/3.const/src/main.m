// tests/3.const/src/main.m

include "libc/ctypes64"
include "libc/stdio"

const genericIntConst = 42
const int32Const = Int32 genericIntConst

const genericStringConst = "Hello!"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst


type Point = record {
	x: Nat32
	y: Nat32
}

type X = record {
	p: Point
	a: [1]Point
}


const ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]

const points = [3]Point ps

const pointZero = Point {x=1, y=1}
const zeroPoints = [3]Point [pointZero, pointZero, pointZero]

var x: X = {
	p=Point{x=10, y=20}
	a=[{x=20, y=30}]
}

@used
var points2 = points


// define function main
public func main () -> Int {
	printf("test const\n")

	var y: X = {
		p=Point{x=10, y=20}
		a=[{x=20, y=30}]
	}

	var points3 = points

	let pp = points[0]
	let ppp = zeroPoints[0]
	let z = pointZero.x

	printf("genericIntConst = %d\n", Int32 genericIntConst)
	printf("int32Const = %d\n", int32Const)

//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const)

	return 0
}


