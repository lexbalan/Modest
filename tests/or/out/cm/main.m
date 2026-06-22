import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"


type Error = @branded Nat32
const errorNone = Error 0
const errorSome = Error 1


@nonstatic
func main () -> Int or Error {
	let x: Error = errorSome
	if x == errorNone {
		printf("No error\n")
	} else {
		printf("Error occurred\n")
	}
	return Int 0
}

