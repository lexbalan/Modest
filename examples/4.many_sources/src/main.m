// examples/4.many_sources/main.m

include "libc/ctypes64"
include "libc/stdio"

import "lib"


func main () -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

