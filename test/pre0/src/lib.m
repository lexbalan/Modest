
include "console"


export type Int Int32

export type Point record {
	x: Int
	y: Int
}

type XXX Int


func div(a: Int, b: Int) -> Int {
	return a / b
}


export func mid(a: Int, b: Int) -> Int {
	let sum = a + b
	return div(sum, 2)
}


export func printPoint(p: Point) -> Unit {
	printf("p.x = %d\n", p.x)
	printf("p.y = %d\n", p.y)
}

