// test/print/src/main.cm

include "libc/ctypes64"

import "lightfood/console"


func main() -> Int {
	console.print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\")           // "\\" = "\"
	console.print("\n")
	console.print("\64")          // "\64" = "@"
	console.print("\n")
	console.print("\x23AA\x23")   // "\x23AA\x23" = "#AA#"
	console.print("\n")
	console.print("\u0001F389A")  // "\u0001F389A" = "🎉A"
	console.print("\n")

	console.print("Это строка записанная кириллицей.\n")

	console.print("{{c}}\n")            // {{c}}
	console.print("c = '{c}'\n", c)     // c = \
	console.print("s = \"{s}\"\n", s)   // s = "Hi!"
	console.print("i = {i}\n", i)       // i = -1
	console.print("n = {n}\n", n)       // n = 123
	console.print("x = 0x{x}\n", x)     // x = 0x1234567F

	return 0
}

