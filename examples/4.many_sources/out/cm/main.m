
@c_include "stdio.h"
import "lib" as lib


public func main() -> ctypes64.Int {
	stdio.printf("hello from main\n")
	lib.foo()
	return 0
}

