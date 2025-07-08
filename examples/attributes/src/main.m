// examples/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


type MyInt32 = @distinct Int32
@set("id.c", "MY_ZERO")
const myZero = MyInt32 0
@set("id.c", "MY_ONE")
const myOne = MyInt32 1


type ProtocolHeader = @packed record {
	start: Word16
	len: Nat16
}

@extern
var ext: Int32

@alignment(8)
@section("__DATA, .xdata")
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

