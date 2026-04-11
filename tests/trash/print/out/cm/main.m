private import "builtin"
private import "lightfood/console"
include "ctypes64"

import "lightfood/console" as console

public func main () -> Int {
	print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	print("\\\n")
	print("@\n")
	print("#AA#\n")
	print("🎉A\n")

	print("Это строка записанная кириллицей.\n")

	print("{{c}}\n")
	print("c = \"{c}\"\n", c)
	print("s = \"{s}\"\n", s)
	print("i = {i}\n", i)
	print("n = {n}\n", n)
	print("x = 0x{x}\n", x)

	return 0
}

