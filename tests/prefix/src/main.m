// examples/prefix/src/main.m

include "libc/stdio"

import "lib"


public func main () -> Int {
	printf("Hello!\n")
	lib.foo()
	return 0
}

