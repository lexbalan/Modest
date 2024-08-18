// module: sub.m
//

export let name = "sub"


export func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}

export func sub(a: Int32, b: Int32) -> Int32 {
	return a - b
}

@inline
export func mid(a: Int32, b: Int32) -> Int32 {
	return (a + b) / 2
}

