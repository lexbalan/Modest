include "ctypes64"
include "stdio"



type Type1 = record {
	x: Int32
}

type Type2 = record {
	x: Int32
}

type Type3 = Type1


func f0_val (x: Type1) -> Unit {
	printf("f0 x.x = %d\n", Int32 x.x)
}

func f1_val (x: Type2) -> Unit {
	printf("f1 x.x = %d\n", Int32 x.x)
}

func f2_val (x: Type3) -> Unit {
	printf("f2 x.x = %d\n", Int32 x.x)
}

func f3_val (x: record {
	x: Int32
}) -> Unit {
	printf("f3 x.x = %d\n", Int32 x.x)
}


func f0_ptr (x: *Type1) -> Unit {
	printf("f0p x.x = %d\n", Int32 x.x)
}

func f1_ptr (x: *Type2) -> Unit {
	printf("f1p x.x = %d\n", Int32 x.x)
}

func f2_ptr (x: *Type3) -> Unit {
	printf("f2p x.x = %d\n", Int32 x.x)
}

func f3_ptr (x: *record {
	x: Int32
}) -> Unit {
	printf("f3p x.x = %d\n", Int32 x.x)
}


var a: Type1 = {x = 1}
var b: Type2 = {x = 2}
var c: Type3 = {x = 3}


func test_by_value () -> Unit {
	f0_val(a)
	f1_val(a)
	f2_val(a)
	f3_val(a)

	f0_val(b)
	f1_val(b)
	f2_val(b)
	f3_val(b)

	f0_val(c)
	f1_val(c)
	f2_val(c)
	f3_val(c)
}


func test_by_pointer () -> Unit {
	f0_ptr(&a)
	f1_ptr(&a)
	f2_ptr(&a)
	f3_ptr(&a)

	f0_ptr(&b)
	f1_ptr(&b)
	f2_ptr(&b)
	f3_ptr(&b)

	f0_ptr(&c)
	f1_ptr(&c)
	f2_ptr(&c)
	f3_ptr(&c)
}


public func main () -> Int {
	test_by_value()
	test_by_pointer()
	return 0
}

