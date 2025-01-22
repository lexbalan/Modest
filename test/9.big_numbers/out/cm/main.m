
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"


var big0: Nat128 = 0x0123456789ABCDEFFEDCBA9876543210


func high_128(x: Word128) -> Word64 {
	return Word64 x >> 64
}


func low_128(x: Word128) -> Word64 {
	return Word64 x and 0xFFFFFFFFFFFFFFFF
}


public func main() -> Int {

	let big1 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

	var big2: Nat128
	big2 = big1

	var big3: Nat128 = 0x1

	var a: Nat32 = 0x1

	var big_sum: Nat128 = big1 + big2 + Nat128 a

	printf("big0 = 0x%llX%llX\n", high_128(Word128 big0), low_128(Word128 big0))
	printf("big1 = 0x%llX%llX\n", high_128(Word128 big1), low_128(Word128 big1))
	printf("big2 = 0x%llX%llX\n", high_128(Word128 big2), low_128(Word128 big2))
	printf("big3 = 0x%llX%llX\n", high_128(Word128 big3), low_128(Word128 big3))
	printf("big_sum = 0x%llX%llX\n", high_128(Word128 big_sum), low_128(Word128 big_sum))


	// signed big int test
	let sig0 = -1

	var sig1: Int128 = sig0

	sig1 = sig1 + 1

	printf("sig1 = %lld\n", Nat64 sig1)

	return 0
}

