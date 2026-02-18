

type Empty = {}

type Simple = {
	x: Int32
}

type Point = {
	x: Int32
	y: Int32
}

type Color = {
	r: Nat8
	g: Nat8
	b: Nat8
	a: Nat8
}

type Nested = {
	pos: Point
	col: Color
}

type WithPointer = {
	data: *Int32
	len: Nat64
}

type WithArray = {
	items: [10]Int32
	count: Nat32
}

// record with 'union' layout
// Not implemented in LLVM backend (!)
type Union = @union {
	_nat: Nat64
	_float: Float64
}


var origin: Point = {x = 0, y = 0}
var red: Color = {r = 255, g = 0, b = 0, a = 255}
var union1: Union

func makePoint (x: Int32, y: Int32) -> Point {
	return {x = x, y = y}
}

func distance (a: Point, b: Point) -> Int32 {
	let dx: Int32 = a.x - b.x
	let dy: Int32 = a.y - b.y
	return dx * dx + dy * dy
}

func modifyPoint (p: *Point) -> {} {
	p.x = p.x + 1
	p.y = p.y + 1
}


func max (a: Nat64, b: Nat64) -> Nat64 {; if a > b {; return a
	}; return b
}

func testUnion () -> Bool {
	var success: Bool = true

	if sizeof(Union) != max(sizeof(Nat64), sizeof(Float64)) {
		success = false
	}

	if alignof(Union) != max(alignof(Nat64), alignof(Float64)) {
		success = false
	}

	if sizeof(Union) != sizeof union1 {
		success = false
	}

	if offsetof(Union._nat) != 0 {
		success = false
	}

	if offsetof(Union._float) != 0 {
		success = false
	}

	return success
}


public func main () -> Int32 {
	var p: Point = makePoint(3, 4)
	var d: Int32 = distance(origin, p)
	modifyPoint(&p)
	var n: Nested = {pos = p, col = red}
	var x: Int32 = n.pos.x
	return 0
}

