// test/1.hello_world/src/main.cm

include "libc/ctypes64"

import "lightfood/console"


let hello = "Hello"
let world = "World!"

let hello_world = hello + " " + world


func main() -> Int {
	//console.print("{s}\n", *Str8 hello_world)

	let c = Char8 "$"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	console.print("\\")
	console.print("\n")

	console.print("\{\}\n")
	console.print("c = '{c}'\n", Char32 c)
	console.print("s = \"{s}\"\n", s)
	console.print("i = {i}\n", i)
	console.print("n = {n}\n", n)
	console.print("x = 0x{x}\n", x)

	return 0
}

