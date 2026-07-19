// tests/print/src/main.m

include "libc/ctypes64"

import "lightfood/console"
pragma c_include "./console.h"


func main () -> Int {
	console.print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\\n")           // "\\" = "\"
	console.print("\x40\n")         // "\x40" = "@"
	console.print("\x23AA\x23\n")   // "\x23AA\x23" = "#AA#"
	console.print("\u{1F389}A\n")   // "\u{1F389}A" = "🎉A"

	console.print("Это строка записанная кириллицей.\n")

	console.print("{{c}}\n")            // {{c}}
	console.print("c = \"{c}\"\n", c)   // c = "🐀"
	console.print("s = \"{s}\"\n", s)   // s = "Hi!"
	console.print("i = {i}\n", i)       // i = -1
	console.print("n = {n}\n", n)       // n = 123
	console.print("x = 0x{x}\n", x)     // x = 0x1234567F

	return 0
}

