import "builtin"


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

public func main () -> Int32 {
	var a: Int32 = identity(42)
	var b: Int32 = add(1, 2)
	var c: Int32 = add3(1, 2, 3)
	nop()
	retUnit()
	var d: Int32 = nested(5)
	var e: Int32 = callChain()
	var f: Int32 = withExprArgs()
	return 0
}

