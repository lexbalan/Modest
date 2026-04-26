// tests/lang/value/call/src/main.m

func identity (x: Int32) -> Int32 {
	return x
}

func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}

func add3 (a: Int32, b: Int32, c: Int32) -> Int32 {
	return a + b + c
}

func nop () -> Unit {
}

func retUnit () -> Unit {
}

func nested (x: Int32) -> Int32 {
	return identity(identity(x))
}

func callChain () -> Int32 {
	return add(add(1, 2), add(3, 4))
}

func withExprArgs () -> Int32 {
	return add(1 + 2, 3 * 4)
}

func main () -> Int32 {
	var a = identity(42)
	var b = add(1, 2)
	var c = add3(1, 2, 3)
	nop()
	retUnit()
	var d = nested(5)
	var e = callChain()
	var f = withExprArgs()
	return 0
}
