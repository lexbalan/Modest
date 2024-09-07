

export type Int Int32

func div(a: Int, b: Int) -> Int {
	return a / b
}

export func mid(a: Int, b: Int) -> Int {
	let sum = a + b
	return div(sum, 2)
}

