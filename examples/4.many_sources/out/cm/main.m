import "builtin"
import "lib"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"
import "lib" as lib


@nonstatic
func main () -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

