private import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"

@nonstatic
func main () -> Int {
	printf("Hello World!\n")
	return 0
}

