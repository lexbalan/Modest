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

var cc8: Char8 = "A"
var cc16: Char16 = "A"
var cc32: Char32 = "A"

var bb8: Str8 = "A"
var bb16: Str16 = "A"
var bb32: Str32 = "A"

var ss8: *Str8 = "A"
var ss16: *Str16 = "A"
var ss32: *Str32 = "A"


public func main () -> Int32 {
	printf("test unicode\n")

	putc8(a)
	putc16(a)
	putc32(a)

	puts8(a)
	puts16(a)
	puts32(a)

	putc8("A")
	putc16("A")
	putc32("A")

	puts8("A")
	puts16("A")
	puts32("A")

	return 0
}


func putc8 (c: Char8) -> Unit {}
func putc16 (c: Char16) -> Unit {}
func putc32 (c: Char32) -> Unit {}

func puts8 (s: *Str8) -> Unit {}
func puts16 (s: *Str16) -> Unit {}
func puts32 (s: *Str32) -> Unit {}

