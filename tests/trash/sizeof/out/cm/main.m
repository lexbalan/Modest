private import "builtin"
include "ctypes64"
include "stdio"



type Point = {
	x: Nat32
	y: Nat32
}

type Mixed1 = {
	c: Char8
	i: Int32
	f: Float64
}

type Mixed2 = {
	i: Int32
	c: Char8
	f: Float64
	c2: [3]Char8
	m: Mixed1
}

type Mixed3 = {
	c: Char8
	i: Int32
	f: Float64
	c2: [9]Char8
}

type Mixed4 = {
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

type X = {
	c: Char8
	i: Int32
	f: Float64
	i2: Int16
	p: [3]Point
	g: Bool
}

var x: X

@nonstatic
func main () -> Int {
	printf("test cast operation\n")

	let start_adr: Nat64 = unsafe Nat64 &c
	printf("off(c) = %llu\n", unsafe Nat64 &c - start_adr)
	printf("off(i) = %llu\n", unsafe Nat64 &i - start_adr)
	printf("off(f) = %llu\n", unsafe Nat64 &f - start_adr)
	printf("off(i2) = %llu\n", unsafe Nat64 &i2 - start_adr)
	printf("off(p) = %llu\n", unsafe Nat64 &p - start_adr)
	printf("off(g) = %llu\n", unsafe Nat64 &g - start_adr)
	printf("sizeof(Unit) = %zu\n", sizeof(Unit))
	printf("alignof(Unit) = %zu\n", alignof(Unit))

	printf("sizeof(Bool) = %zu\n", sizeof(Bool))
	printf("alignof(Bool) = %zu\n", alignof(Bool))

	printf("sizeof(Nat8) = %zu\n", sizeof(Nat8))
	printf("alignof(Nat8) = %zu\n", alignof(Nat8))
	printf("sizeof(Nat16) = %zu\n", sizeof(Nat16))
	printf("alignof(Nat16) = %zu\n", alignof(Nat16))
	printf("sizeof(Nat32) = %zu\n", sizeof(Nat32))
	printf("alignof(Nat32) = %zu\n", alignof(Nat32))
	printf("sizeof(Nat64) = %zu\n", sizeof(Nat64))
	printf("alignof(Nat64) = %zu\n", alignof(Nat64))
	printf("sizeof(Nat128) = %zu\n", sizeof(Nat128))
	printf("alignof(Nat128) = %zu\n", alignof(Nat128))

	printf("sizeof(Int8) = %zu\n", sizeof(Int8))
	printf("alignof(Int8) = %zu\n", alignof(Int8))
	printf("sizeof(Int16) = %zu\n", sizeof(Int16))
	printf("alignof(Int16) = %zu\n", alignof(Int16))
	printf("sizeof(Int32) = %zu\n", sizeof(Int32))
	printf("alignof(Int32) = %zu\n", alignof(Int32))
	printf("sizeof(Int64) = %zu\n", sizeof(Int64))
	printf("alignof(Int64) = %zu\n", alignof(Int64))
	printf("sizeof(Int128) = %zu\n", sizeof(Int128))
	printf("alignof(Int128) = %zu\n", alignof(Int128))

	printf("sizeof(Char8) = %zu\n", sizeof(Char8))
	printf("alignof(Char8) = %zu\n", alignof(Char8))
	printf("sizeof(Char16) = %zu\n", sizeof(Char16))
	printf("alignof(Char16) = %zu\n", alignof(Char16))
	printf("sizeof(Char32) = %zu\n", sizeof(Char32))
	printf("alignof(Char32) = %zu\n", alignof(Char32))
	printf("sizeof(*Str8) = %zu\n", sizeof(*Str8))
	printf("alignof(*Str8) = %zu\n", alignof(*Str8))
	printf("sizeof([10]Int32) = %zu\n", sizeof([10]Int32))
	printf("alignof([10]Int32) = %zu\n", alignof([10]Int32))

	printf("> alignof([3]Point) = %zu\n", alignof([3]Point))
	printf("sizeof(Point) = %zu\n", sizeof(Point))
	printf("alignof(Point) = %zu\n", alignof(Point))


	printf("sizeof(Mixed1) = %zu\n", sizeof(Mixed1))
	printf("alignof(Mixed1) = %zu\n", alignof(Mixed1))

	printf("sizeof(Mixed2) = %zu\n", sizeof(Mixed2))
	printf("alignof(Mixed2) = %zu\n", alignof(Mixed2))


	printf("sizeof(Mixed3) = %zu\n", sizeof(Mixed3))
	printf("alignof(Mixed3) = %zu\n", alignof(Mixed3))

	printf("sizeof(Mixed4) = %zu\n", sizeof(Mixed4))
	printf("alignof(Mixed4) = %zu\n", alignof(Mixed4))

	return 0
}

