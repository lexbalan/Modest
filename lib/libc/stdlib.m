// libc/stdlib.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "stdlib.h"

include "ctypes64"

export {
	func abort() -> Unit
	func abs(x: Int) -> Int
	func atexit(x: *()->Unit) -> Int
	func atof(nptr: *[]ConstChar) -> Double
	func atoi(nptr: *[]ConstChar) -> Int
	func atol(nptr: *[]ConstChar) -> LongInt
	func calloc(num: SizeT, size: SizeT) -> Ptr
	func exit(x: Int) -> Unit
	func free(ptr: Ptr) -> Unit
	func getenv(name: *Str) -> *Str
	func labs(x: LongInt) -> LongInt
	func secure_getenv(name: *Str) -> *Str
	func malloc(size: SizeT) -> Ptr
	func system(string: *[]ConstChar) -> Int
}
