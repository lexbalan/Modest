import "builtin"
import "lib"
include "stdio"

import "lib" as lib


public func main () -> Int {
	lib.foo(lib.bar)
	Unit lib.spam
	return 0
}

