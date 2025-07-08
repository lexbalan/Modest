include "ctypes64"
include "stdio"
// examples/1.hello_world/src/main.m


type ProtocolHeader = @packed record {
	start: Word16
	len: Nat16
}


@extern
var ext: Int32



@section("__DATA, .xdata")
@alignment(8)
var x: Word32




@inline
func staticInlineFunc (x: Int32) -> Int32 {
	return x + 1
}


@noinline
func staticNoinlineFunc (x: Int32) -> Int32 {
	return x + 1
}


public func main () -> Int {
	printf("Attributes example\n")
	return 0
}

