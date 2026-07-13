import "builtin"
import "lib"
include "stdio"

include "libc/stdio"
import "lib" as lib


@nonstatic
func main () -> Int {
	lib.foo(lib.bar)
	Unit lib.spam
	return 0
}

