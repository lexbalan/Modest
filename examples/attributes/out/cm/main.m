include "ctypes64"
include "stdio"
// examples/1.hello_world/src/main.m






@section("__DATA, .xdata")
@alignment(8)
var x: Word32


@extern
var ext: Int32


public func main () -> Int {
	printf("Attributes example\n")
	return 0
}

