include "ctypes64"
include "stdio"



type Point record {
	x: Nat32
	y: Nat32
}

type Mixed1 record {
	c: Char8
	i: Int32
	f: Float64
}

type Mixed2 record {
	i: Int32
	c: Char8
	f: Float64
	c2: [3]Char8
	m: Mixed1
}

type Mixed3 record {
	c: Char8
	i: Int32
	f: Float64
	c2: [9]Char8
}

type Mixed4 record {
	s: Mixed2
	c: Char8
	i: Int32
	f: Float64
	c2: [9]Char8
	i2: Int16
	p: [3]Point
	s2: Mixed3
}


//var s: Mixed2
var c: Char8
var i: Int32
var f: Float64
var i2: Int16
var p: [3]Point
var g: Bool

type X record {
	c: Char8
	i: Int32
	f: Float64
	i2: Int16
	p: [3]Point
	g: Bool
}

var x: X

public func main() -> Int {
	stdio.printf("test cast operation\n")

	let start_adr = Nat64 &c
	stdio.printf("off(c) = %llu\n", Nat64 &c - start_adr)
	stdio.printf("off(i) = %llu\n", Nat64 &i - start_adr)
	stdio.printf("off(f) = %llu\n", Nat64 &f - start_adr)
	stdio.printf("off(i2) = %llu\n", Nat64 &i2 - start_adr)
	stdio.printf("off(p) = %llu\n", Nat64 &p - start_adr)
	stdio.printf("off(g) = %llu\n", Nat64 &g - start_adr)

	// дженерики в с явно не приводятся, но нектороые нужно!
	//	printf("offsetof(x.c) = %llu\n", Nat64 offsetof(X.c))
	//	printf("offsetof(x.i) = %llu\n", Nat64 offsetof(X.i))
	//	printf("offsetof(x.f) = %llu\n", Nat64 offsetof(X.f))
	//	printf("offsetof(x.i2) = %llu\n", Nat64 offsetof(X.i2))
	//	printf("offsetof(x.p) = %llu\n", Nat64 offsetof(X.p))
	//	printf("offsetof(x.g) = %llu\n", Nat64 offsetof(X.g))


	// sizeof(void) in C  == 1
	// sizeof(Unit) in CM == 0
	// TODO: here is a broblem
	stdio.printf("sizeof(Unit) = %llu\n", Nat64 sizeof(Unit))
	stdio.printf("alignof(Unit) = %llu\n", Nat64 alignof(Unit))

	stdio.printf("sizeof(Bool) = %llu\n", Nat64 sizeof(Bool))
	stdio.printf("alignof(Bool) = %llu\n", Nat64 alignof(Bool))

	stdio.printf("sizeof(Nat8) = %llu\n", Nat64 sizeof(Nat8))
	stdio.printf("alignof(Nat8) = %llu\n", Nat64 alignof(Nat8))
	stdio.printf("sizeof(Nat16) = %llu\n", Nat64 sizeof(Nat16))
	stdio.printf("alignof(Nat16) = %llu\n", Nat64 alignof(Nat16))
	stdio.printf("sizeof(Nat32) = %llu\n", Nat64 sizeof(Nat32))
	stdio.printf("alignof(Nat32) = %llu\n", Nat64 alignof(Nat32))
	stdio.printf("sizeof(Nat64) = %llu\n", Nat64 sizeof(Nat64))
	stdio.printf("alignof(Nat64) = %llu\n", Nat64 alignof(Nat64))
	stdio.printf("sizeof(Nat128) = %llu\n", Nat64 sizeof(Nat128))
	stdio.printf("alignof(Nat128) = %llu\n", Nat64 alignof(Nat128))
	// type Nat256 not implemented
	//printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))

	stdio.printf("sizeof(Int8) = %llu\n", Nat64 sizeof(Int8))
	stdio.printf("alignof(Int8) = %llu\n", Nat64 alignof(Int8))
	stdio.printf("sizeof(Int16) = %llu\n", Nat64 sizeof(Int16))
	stdio.printf("alignof(Int16) = %llu\n", Nat64 alignof(Int16))
	stdio.printf("sizeof(Int32) = %llu\n", Nat64 sizeof(Int32))
	stdio.printf("alignof(Int32) = %llu\n", Nat64 alignof(Int32))
	stdio.printf("sizeof(Int64) = %llu\n", Nat64 sizeof(Int64))
	stdio.printf("alignof(Int64) = %llu\n", Nat64 alignof(Int64))
	stdio.printf("sizeof(Int128) = %llu\n", Nat64 sizeof(Int128))
	stdio.printf("alignof(Int128) = %llu\n", Nat64 alignof(Int128))
	// type Int256 not implemented
	//printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))

	stdio.printf("sizeof(Char8) = %llu\n", Nat64 sizeof(Char8))
	stdio.printf("alignof(Char8) = %llu\n", Nat64 alignof(Char8))
	stdio.printf("sizeof(Char16) = %llu\n", Nat64 sizeof(Char16))
	stdio.printf("alignof(Char16) = %llu\n", Nat64 alignof(Char16))
	stdio.printf("sizeof(Char32) = %llu\n", Nat64 sizeof(Char32))
	stdio.printf("alignof(Char32) = %llu\n", Nat64 alignof(Char32))

	// pointer size (for example pointer to []Char8)
	stdio.printf("sizeof(*Str8) = %llu\n", Nat64 sizeof(*Str8))
	stdio.printf("alignof(*Str8) = %llu\n", Nat64 alignof(*Str8))

	// array size
	stdio.printf("sizeof([10]Int32) = %llu\n", Nat64 sizeof([10]Int32))
	stdio.printf("alignof([10]Int32) = %llu\n", Nat64 alignof([10]Int32))

	stdio.printf("> alignof([3]Point) = %llu\n", Nat64 alignof([3]Point))


	// record size
	stdio.printf("sizeof(Point) = %llu\n", Nat64 sizeof(Point))
	stdio.printf("alignof(Point) = %llu\n", Nat64 alignof(Point))

	//	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	//	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))


	stdio.printf("sizeof(Mixed1) = %llu\n", Nat64 sizeof(Mixed1))
	stdio.printf("alignof(Mixed1) = %llu\n", Nat64 alignof(Mixed1))

	stdio.printf("sizeof(Mixed2) = %llu\n", Nat64 sizeof(Mixed2))
	stdio.printf("alignof(Mixed2) = %llu\n", Nat64 alignof(Mixed2))


	//	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	//	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	//	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	//	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	//	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))


	stdio.printf("sizeof(Mixed3) = %llu\n", Nat64 sizeof(Mixed3))
	stdio.printf("alignof(Mixed3) = %llu\n", Nat64 alignof(Mixed3))

	stdio.printf("sizeof(Mixed4) = %llu\n", Nat64 sizeof(Mixed4))
	stdio.printf("alignof(Mixed4) = %llu\n", Nat64 alignof(Mixed4))

	//	printf("offsetof(Mixed4.s) = %llu\n", Nat64 offsetof(Mixed4.s))
	//	printf("offsetof(Mixed4.c) = %llu\n", Nat64 offsetof(Mixed4.c))
	//	printf("offsetof(Mixed4.i) = %llu\n", Nat64 offsetof(Mixed4.i))
	//	printf("offsetof(Mixed4.f) = %llu\n", Nat64 offsetof(Mixed4.f))
	//	printf("offsetof(Mixed4.c2) = %llu\n", Nat64 offsetof(Mixed4.c2))
	//	printf("offsetof(Mixed4.i2) = %llu\n", Nat64 offsetof(Mixed4.i2))
	//	printf("offsetof(Mixed4.p) = %llu\n", Nat64 offsetof(Mixed4.p))
	//	printf("offsetof(Mixed4.s2) = %llu\n", Nat64 offsetof(Mixed4.s2))

	return 0
}

