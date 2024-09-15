// libc/ctype.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "ctype.h"

include "ctypes64"

export {
	extern func isascii(x: Int) -> Bool
	extern func iscntrl(x: Int) -> Bool
	extern func isblank(x: Int) -> Bool
	extern func isdigit(x: Int) -> Bool
	extern func isxdigit(x: Int) -> Bool
	extern func isalpha(x: Int) -> Bool
	extern func isalnum(x: Int) -> Bool
	extern func isgraph(x: Int) -> Bool
	extern func isprint(x: Int) -> Bool
	extern func ispunct(x: Int) -> Bool
	extern func isspace(x: Int) -> Bool
	extern func isupper(x: Int) -> Bool
	extern func islower(x: Int) -> Bool

	extern func toascii(x: Int) -> Int
	extern func toupper(x: Int) -> Int
	extern func tolower(x: Int) -> Int
}
