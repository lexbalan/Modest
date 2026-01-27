include "ctypes64"
include "stdio"



type Point = record {
	x: Nat32
	y: Nat32
}

type Mixed1 = record {
	c: Char8
	i: Int32
	f: Float64
}

type Mixed2 = record {
	i: Int32
	c: Char8
	f: Float64
	c2: [3]Char8
	m: Mixed1
}

type Mixed3 = record {
	c: Char8
	i: Int32
	f: Float64
	c2: [9]Char8
}

type Mixed4 = record {
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

type X = record {
	c: Char8
	i: Int32
	f: Float64
	i2: Int16
	p: [3]Point
	g: Bool
}

var x: X

public func main () -> Int {
	printf("test cast operation\n")

	let start_adr: Nat64 = unsafe Nat64 &c
	printf("off(c) = %llu\n", Nat64 unsafe Nat64 &c - start_adr)
	printf("off(i) = %llu\n", Nat64 unsafe Nat64 &i - start_adr)
	printf("off(f) = %llu\n", Nat64 unsafe Nat64 &f - start_adr)
	printf("off(i2) = %llu\n", Nat64 unsafe Nat64 &i2 - start_adr)
	printf("off(p) = %llu\n", Nat64 unsafe Nat64 &p - start_adr)
	printf("off(g) = %llu\n", Nat64 unsafe Nat64 &g - start_adr)

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
	printf("sizeof(Unit) = %zu\n", Size sizeof(Unit))
	printf("alignof(Unit) = %zu\n", Size alignof(Unit))

	printf("sizeof(Bool) = %zu\n", Size sizeof(Bool))
	printf("alignof(Bool) = %zu\n", Size alignof(Bool))

	printf("sizeof(Nat8) = %zu\n", Size sizeof(Nat8))
	printf("alignof(Nat8) = %zu\n", Size alignof(Nat8))
	printf("sizeof(Nat16) = %zu\n", Size sizeof(Nat16))
	printf("alignof(Nat16) = %zu\n", Size alignof(Nat16))
	printf("sizeof(Nat32) = %zu\n", Size sizeof(Nat32))
	printf("alignof(Nat32) = %zu\n", Size alignof(Nat32))
	printf("sizeof(Nat64) = %zu\n", Size sizeof(Nat64))
	printf("alignof(Nat64) = %zu\n", Size alignof(Nat64))
	printf("sizeof(Nat128) = %zu\n", Size sizeof(Nat128))
	printf("alignof(Nat128) = %zu\n", Size alignof(Nat128))
	// type Nat256 not implemented
	//printf("sizeof(Nat256) = %zu\n", sizeof(Nat256))

	printf("sizeof(Int8) = %zu\n", Size sizeof(Int8))
	printf("alignof(Int8) = %zu\n", Size alignof(Int8))
	printf("sizeof(Int16) = %zu\n", Size sizeof(Int16))
	printf("alignof(Int16) = %zu\n", Size alignof(Int16))
	printf("sizeof(Int32) = %zu\n", Size sizeof(Int32))
	printf("alignof(Int32) = %zu\n", Size alignof(Int32))
	printf("sizeof(Int64) = %zu\n", Size sizeof(Int64))
	printf("alignof(Int64) = %zu\n", Size alignof(Int64))
	printf("sizeof(Int128) = %zu\n", Size sizeof(Int128))
	printf("alignof(Int128) = %zu\n", Size alignof(Int128))
	// type Int256 not implemented
	//printf("sizeof(Int256) = %zu\n", sizeof(Int256))

	printf("sizeof(Char8) = %zu\n", Size sizeof(Char8))
	printf("alignof(Char8) = %zu\n", Size alignof(Char8))
	printf("sizeof(Char16) = %zu\n", Size sizeof(Char16))
	printf("alignof(Char16) = %zu\n", Size alignof(Char16))
	printf("sizeof(Char32) = %zu\n", Size sizeof(Char32))
	printf("alignof(Char32) = %zu\n", Size alignof(Char32))

	// pointer size (for example pointer to []Char8)
	printf("sizeof(*Str8) = %zu\n", Size sizeof(*Str8))
	printf("alignof(*Str8) = %zu\n", Size alignof(*Str8))

	// array size
	printf("sizeof([10]Int32) = %zu\n", Size sizeof([10]Int32))
	printf("alignof([10]Int32) = %zu\n", Size alignof([10]Int32))

	printf("> alignof([3]Point) = %zu\n", Size alignof([3]Point))


	// record size
	printf("sizeof(Point) = %zu\n", Size sizeof(Point))
	printf("alignof(Point) = %zu\n", Size alignof(Point))

	//	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	//	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))


	printf("sizeof(Mixed1) = %zu\n", Size sizeof(Mixed1))
	printf("alignof(Mixed1) = %zu\n", Size alignof(Mixed1))

	printf("sizeof(Mixed2) = %zu\n", Size sizeof(Mixed2))
	printf("alignof(Mixed2) = %zu\n", Size alignof(Mixed2))


	//	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	//	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	//	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	//	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	//	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))


	printf("sizeof(Mixed3) = %zu\n", Size sizeof(Mixed3))
	printf("alignof(Mixed3) = %zu\n", Size alignof(Mixed3))

	printf("sizeof(Mixed4) = %zu\n", Size sizeof(Mixed4))
	printf("alignof(Mixed4) = %zu\n", Size alignof(Mixed4))

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

