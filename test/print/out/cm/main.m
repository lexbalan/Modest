
include "libc/ctypes64"
import "lightfood/console"
func main() -> Int {
	console.print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\\\")
	console.print("\n")

	console.print("\\{{\\}}\n")
	console.print("c = '{c}'\n", c)
	console.print("s = \"{s}\"\n", s)
	console.print("i = {i}\n", i)
	console.print("n = {n}\n", n)
	console.print("x = 0x{x}\n", x)

	return 0
}

