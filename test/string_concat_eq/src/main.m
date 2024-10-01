// test/string_concat_eq/src/main.cm

include "libc/ctypes64"
include "libc/stdio"

let hello = "Hello"
let world = "World"
let party_corn = "🎉"

let greeting = hello + " " + world //+ " " + party_corn


let test = "test"


func main() -> Int {
	printf("%s\n", *Str8 greeting)

	if test == "test" {
		printf("test ok.\n")
	} else {
		printf("test failed.\n")
	}

	return 0
}

