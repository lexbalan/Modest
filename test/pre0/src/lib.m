
include "console"


public type Int Int32

public type Point record {
	x: Int
	y: Int
}

type XXX Int


func div(a: Int, b: Int) -> Int {
	return a / b
}


public func mid(a: Int, b: Int) -> Int {
	let sum = a + b
	return div(sum, 2)
}


public func printPoint(p: Point) -> Unit {
	printf("p.x = %d\n", p.x)
	printf("p.y = %d\n", p.y)
}

