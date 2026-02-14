// tests/lang/def/func/src/main.m

// simple function no args
func nop () -> Unit {
}

// function with return
func one () -> Int32 {
	return 1
}

// function with args
func add (a: Int32, b: Int32) -> Int32 {
	return a + b
}

// function returning bool
func isPositive (x: Int32) -> Bool {
	return x > 0
}

// function with pointer arg
func inc (p: *Int32) -> Unit {
	*p = *p + 1
}

// function with default parameter
func greet (name: *Str8 = "World") -> Unit {
}

// function with record arg
func getX (p: {x: Int32, y: Int32}) -> Int32 {
	return p.x
}

// function with record return
func makePoint (x: Int32, y: Int32) -> {x: Int32, y: Int32} {
	return {x = x, y = y}
}

// function with pointer to array arg
func firstOf (arr: *[5]Int32) -> Int32 {
	return (*arr)[0]
}

// nested function calls
func double (x: Int32) -> Int32 {
	return x + x
}

func quadruple (x: Int32) -> Int32 {
	return double(double(x))
}

// public function
public func main () -> Int32 {
	nop()
	var x = one()
	x = add(1, 2)
	var y = isPositive(x)
	inc(&x)
	greet()
	greet("Alex")
	var p = makePoint(1, 2)
	var z = getX(p)
	z = quadruple(3)
	return 0
}
