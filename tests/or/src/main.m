// tests/0/src/main.m

include "libc/ctypes64"
include "libc/stdio"

type Error = @branded Nat32
const errorNone = Error 0
const errorSome = Error 1

func main () -> Int or Error {
	let x = errorSome
	if x == errorNone {
		printf("No error\n")
	} else {
		printf("Error occurred\n")
	}
	return 0
}
