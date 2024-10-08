// libc/ctype.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "ctype.h"

include "ctypes64"

export {
	func isascii(x: Int) -> Bool
	func iscntrl(x: Int) -> Bool
	func isblank(x: Int) -> Bool
	func isdigit(x: Int) -> Bool
	func isxdigit(x: Int) -> Bool
	func isalpha(x: Int) -> Bool
	func isalnum(x: Int) -> Bool
	func isgraph(x: Int) -> Bool
	func isprint(x: Int) -> Bool
	func ispunct(x: Int) -> Bool
	func isspace(x: Int) -> Bool
	func isupper(x: Int) -> Bool
	func islower(x: Int) -> Bool

	func toascii(x: Int) -> Int
	func toupper(x: Int) -> Int
	func tolower(x: Int) -> Int
}
