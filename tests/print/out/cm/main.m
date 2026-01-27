import "lightfood/console"
include "ctypes64"

import "lightfood/console" as console

public func main () -> Int {
	console.print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\\n")// "\\" = "\"
	console.print("@\n")// "\64" = "@"
	console.print("#AA#\n")// "\x23AA\x23" = "#AA#"
	console.print("🎉A\n")// "\u0001F389A" = "🎉A"

	console.print("Это строка записанная кириллицей.\n")

	console.print("{{c}}\n")// {{c}}
	console.print("c = \"{c}\"\n", Char32 c)// c = "🐀"
	console.print("s = \"{s}\"\n", *Str8 s)// s = "Hi!"
	console.print("i = {i}\n", Int32 i)// i = -1
	console.print("n = {n}\n", Nat32 n)// n = 123
	console.print("x = 0x{x}\n", Nat32 x)// x = 0x1234567F

	return 0
}

