include "ctypes64"
include "stdio"


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
	a: [3]Point
}


const ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]

const points = [3]Point ps

const pointZero = Point {x = 1, y = 1}
const zeroPoints = [3]Point [pointZero, pointZero, pointZero]

var x: X = {
	p = Point {x = 10, y = 20}
	a = [{x = 20, y = 30}]
}


@used
var points2: [3]Point = points


// define function main
public func main () -> Int {
	printf("test const\n")

	var y: X = {
		p = Point {x = 10, y = 20}
		a = [{x = 20, y = 30}]
	}

	var points3: [3]Point = points

	let pp: Point = points[0]
	let ppp: Point = zeroPoints[0]
	let z: Nat32 = pointZero.x

	printf("genericIntConst = %d\n", Int32 genericIntConst)
	printf("int32Const = %d\n", int32Const)

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const)

	return 0
}

