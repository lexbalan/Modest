
import "lightfood/console" as console


public func main() -> ctypes64.Int {
	console.print("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\\n")
	console.print("@\n")
	console.print("#AA#\n")
	console.print("🎉A\n")

	console.print("Это строка записанная кириллицей.\n")

	console.print("{{c}}\n")
	console.print("c = \"{c}\"\n", c)
	console.print("s = \"{s}\"\n", s)
	console.print("i = {i}\n", i)
	console.print("n = {n}\n", n)
	console.print("x = 0x{x}\n", x)

	return 0
}

