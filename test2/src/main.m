// unicode support test

include "libc/stdio"
include "libc/stdlib"
include "libc/string"


const a = "A"


var c8: Char8 = a
var c16: Char16 = a
var c32: Char32 = a

var b8: Str8 = a
var b16: Str16 = a
var b32: Str32 = a

var s8: *Str8 = a
var s16: *Str16 = a
var s32: *Str32 = a


public func main () -> Int32 {
	printf("test2\n")
	putc8("A")
	putc16("A")
	putc32("A")
	return 0
}


func putc8 (c: Char8) -> Unit {}
func putc16 (c: Char16) -> Unit {}
func putc32 (c: Char32) -> Unit {}

