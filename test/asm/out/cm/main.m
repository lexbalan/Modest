
@c_include "stdio.h"


func sum64(a: Int64, b: Int64) -> Int64 {
	var sum: Int64
	__asm("add %0, %1, %2", [["=r", sum]], [["r", a], ["r", b]], ["cc"])
	return sum
}


func sub64(a: Int64, b: Int64) -> Int64 {
	var sub: Int64
	__asm("sub %0, %1, %2", [["=r", sub]], [["r", a], ["r", b]], ["cc"])
	return sub
}


func sumsub64(a: Int64, b: Int64) -> Unit {
	var sum: Int64
	var sub: Int64

	__asm("add %0, %2, %3\nsub %1, %2, %3\n", [["=&r", sum], ["=&r", sub]], [["r", a], ["r", b]], ["cc"])

	stdio.printf("sumsub64 sum = %lld\n", sum)
	stdio.printf("sumsub64 sub = %lld\n", sub)
}


public func main() -> ctypes64.Int {
	stdio.printf("inline asm test\n")

	var a: Int64 = 10
	var b: Int64 = 20

	let sum = sum64(a, b)
	let sub = sub64(a, b)

	stdio.printf("sum(%lld, %lld) = %lld\n", a, b, sum)
	stdio.printf("sub(%lld, %lld) = %lld\n", a, b, sub)

	sumsub64(a, b)

	return 0
}

