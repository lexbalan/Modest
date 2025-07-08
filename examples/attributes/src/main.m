// examples/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


@alignment(2)
@section("__DATA, .xdata")
var x: Int32



public func main () -> Int {
	printf("Attributes example\n")
	return 0
}

