
@attribute("c-no-print")
func printf(s: *Str8, ...)

export type Point record {
	x: Int32
	y: Int32
}

export type Int Int32

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

