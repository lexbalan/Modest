// examples/4.many_sources/main.cm

include "libc/ctypes64"
include "libc/stdio"

import "lib"


func main() -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

