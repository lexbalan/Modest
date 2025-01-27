
@c_include "stdio.h"
import "lib" as lib


public func main() -> Int {
	printf("hello from main\n")
	lib.foo()
	return 0
}

