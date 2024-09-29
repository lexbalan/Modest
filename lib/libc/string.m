// libc/string.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "string.h"

include "ctypes64"

export {
	@unused_result
	func memset(mem: Ptr, c: Int, n: SizeT) -> Ptr
	@unused_result
	func memcpy(dst: Ptr, src: Ptr, len: SizeT) -> Ptr
	@unused_result
	func memmove(dst: Ptr, src: Ptr, n: SizeT) -> Ptr
	func memcmp(p0: Ptr, p1: Ptr, num: SizeT) -> Int
	func strncmp(s1: *[]ConstChar, s2: *[]ConstChar, n: SizeT) -> Int
	func strcmp(s1: *[]ConstChar, s2: *[]ConstChar) -> Int
	@unused_result
	func strcpy(dst: *[]Char, src: *[]ConstChar) -> *[]Char
	func strlen(s: *[]ConstChar) -> SizeT
	func strcat(s1: *[]Char, s2: *[]ConstChar) -> *[]Char
	func strncat(s1: *[]Char, s2: *[]ConstChar, n: SizeT) -> *[]Char
	func strerror(error: Int) -> *[]Char
}
