
@c_include "stdio.h"


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
	c2: [<str_value>]Char8
	m: Mixed1
}

type Mixed3 record {
	c: Char8
	i: Int32
	f: Float64
	c2: [<str_value>]Char8
}

type Mixed4 record {
	s: Mixed2
	c: Char8
	i: Int32
	f: Float64
	c2: [<str_value>]Char8
	i2: Int16
	p: [<str_value>]Point
	s2: Mixed3
}


//var s: Mixed2
var c: Char8
var i: Int32
var f: Float64
var i2: Int16
var p: [<str_value>]Point
var g: Bool

type X record {
	c: Char8
	i: Int32
	f: Float64
	i2: Int16
	p: [<str_value>]Point
	g: Bool
}

var x: X

public func main() -> Int {
	stdio.("test cast operation\n")

	let start_adr = Nat64 &c
	stdio.("off(c) = %llu\n", Nat64 &c - start_adr)
	stdio.("off(i) = %llu\n", Nat64 &i - start_adr)
	stdio.("off(f) = %llu\n", Nat64 &f - start_adr)
	stdio.("off(i2) = %llu\n", Nat64 &i2 - start_adr)
	stdio.("off(p) = %llu\n", Nat64 &p - start_adr)
	stdio.("off(g) = %llu\n", Nat64 &g - start_adr)

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
	stdio.("sizeof(Unit) = %llu\n", Nat64 sizeof(Unit))
	stdio.("alignof(Unit) = %llu\n", Nat64 alignof(Unit))

	stdio.("sizeof(Bool) = %llu\n", Nat64 sizeof(Bool))
	stdio.("alignof(Bool) = %llu\n", Nat64 alignof(Bool))

	stdio.("sizeof(Nat8) = %llu\n", Nat64 sizeof(Nat8))
	stdio.("alignof(Nat8) = %llu\n", Nat64 alignof(Nat8))
	stdio.("sizeof(Nat16) = %llu\n", Nat64 sizeof(Nat16))
	stdio.("alignof(Nat16) = %llu\n", Nat64 alignof(Nat16))
	stdio.("sizeof(Nat32) = %llu\n", Nat64 sizeof(Nat32))
	stdio.("alignof(Nat32) = %llu\n", Nat64 alignof(Nat32))
	stdio.("sizeof(Nat64) = %llu\n", Nat64 sizeof(Nat64))
	stdio.("alignof(Nat64) = %llu\n", Nat64 alignof(Nat64))
	stdio.("sizeof(Nat128) = %llu\n", Nat64 sizeof(Nat128))
	stdio.("alignof(Nat128) = %llu\n", Nat64 alignof(Nat128))
	// type Nat256 not implemented
	//printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))

	stdio.("sizeof(Int8) = %llu\n", Nat64 sizeof(Int8))
	stdio.("alignof(Int8) = %llu\n", Nat64 alignof(Int8))
	stdio.("sizeof(Int16) = %llu\n", Nat64 sizeof(Int16))
	stdio.("alignof(Int16) = %llu\n", Nat64 alignof(Int16))
	stdio.("sizeof(Int32) = %llu\n", Nat64 sizeof(Int32))
	stdio.("alignof(Int32) = %llu\n", Nat64 alignof(Int32))
	stdio.("sizeof(Int64) = %llu\n", Nat64 sizeof(Int64))
	stdio.("alignof(Int64) = %llu\n", Nat64 alignof(Int64))
	stdio.("sizeof(Int128) = %llu\n", Nat64 sizeof(Int128))
	stdio.("alignof(Int128) = %llu\n", Nat64 alignof(Int128))
	// type Int256 not implemented
	//printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))

	stdio.("sizeof(Char8) = %llu\n", Nat64 sizeof(Char8))
	stdio.("alignof(Char8) = %llu\n", Nat64 alignof(Char8))
	stdio.("sizeof(Char16) = %llu\n", Nat64 sizeof(Char16))
	stdio.("alignof(Char16) = %llu\n", Nat64 alignof(Char16))
	stdio.("sizeof(Char32) = %llu\n", Nat64 sizeof(Char32))
	stdio.("alignof(Char32) = %llu\n", Nat64 alignof(Char32))

	// pointer size (for example pointer to []Char8)
	stdio.("sizeof(*Str8) = %llu\n", Nat64 sizeof(*Str8))
	stdio.("alignof(*Str8) = %llu\n", Nat64 alignof(*Str8))

	// array size
	stdio.("sizeof([10]Int32) = %llu\n", Nat64 sizeof([<str_value>]Int32))
	stdio.("alignof([10]Int32) = %llu\n", Nat64 alignof([<str_value>]Int32))

	stdio.("> alignof([3]Point) = %llu\n", Nat64 alignof([<str_value>]Point))


	// record size
	stdio.("sizeof(Point) = %llu\n", Nat64 sizeof(Point))
	stdio.("alignof(Point) = %llu\n", Nat64 alignof(Point))

	//	printf("offsetof(Point.x) = %llu\n", Nat64 offsetof(Point.x))
	//	printf("offsetof(Point.y) = %llu\n", Nat64 offsetof(Point.y))


	stdio.("sizeof(Mixed1) = %llu\n", Nat64 sizeof(Mixed1))
	stdio.("alignof(Mixed1) = %llu\n", Nat64 alignof(Mixed1))

	stdio.("sizeof(Mixed2) = %llu\n", Nat64 sizeof(Mixed2))
	stdio.("alignof(Mixed2) = %llu\n", Nat64 alignof(Mixed2))


	//	printf("offsetof(Mixed2.i) = %llu\n", Nat64 offsetof(Mixed2.i))
	//	printf("offsetof(Mixed2.c) = %llu\n", Nat64 offsetof(Mixed2.c))
	//	printf("offsetof(Mixed2.f) = %llu\n", Nat64 offsetof(Mixed2.f))
	//	printf("offsetof(Mixed2.c2) = %llu\n", Nat64 offsetof(Mixed2.c2))
	//	printf("offsetof(Mixed2.m) = %llu\n", Nat64 offsetof(Mixed2.m))


	stdio.("sizeof(Mixed3) = %llu\n", Nat64 sizeof(Mixed3))
	stdio.("alignof(Mixed3) = %llu\n", Nat64 alignof(Mixed3))

	stdio.("sizeof(Mixed4) = %llu\n", Nat64 sizeof(Mixed4))
	stdio.("alignof(Mixed4) = %llu\n", Nat64 alignof(Mixed4))

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

