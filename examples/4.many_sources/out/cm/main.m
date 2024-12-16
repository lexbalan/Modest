
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
import "lib"


public func main() -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

