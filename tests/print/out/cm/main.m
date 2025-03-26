
import "lightfood/console" as console


public func main() -> Int {
	console.("test console print\n")

	let c = Char32 "🐀"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.("\\\n")
	console.("@\n")
	console.("#AA#\n")
	console.("🎉A\n")

	console.("Это строка записанная кириллицей.\n")

	console.("{{c}}\n")
	console.("c = \"{c}\"\n", c)
	console.("s = \"{s}\"\n", s)
	console.("i = {i}\n", i)
	console.("n = {n}\n", n)
	console.("x = 0x{x}\n", x)

	return 0
}

