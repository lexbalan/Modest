// examples/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


type MyInt32 = @distinct Int32
@set("id.c", "MY_ZERO")
const myZero = MyInt32 0
@set("id.c", "MY_ONE")
const myOne = MyInt32 1

// These refined MyInt32 types are compatible with MyInt32
// but not compatible with anything else (e.g. between them)
type MyInt32_2 = @refined MyInt32
type MyInt32_3 = @refined MyInt32


type ProtocolHeader = @packed record {
	start: Word16
	len: Nat16
}

@extern
var ext: Int32

@alignment(8)
@section("__DATA, .xdata")
var x: Word32


@nonstatic
var s: Nat16


@nodecorate
public const const0 = 0


@inline
func staticInlineFunc (x: Int32) -> Int32 {
	return x + 1
}


@noinline
func staticNoinlineFunc (x: Int32) -> Int32 {
	return x + 1
}


@inlinehint
func staticInlineHintFunc (x: Int32) -> Int32 {
	return x + 1
}


public func main () -> Int {
	printf("Attributes example\n")
	return 0
}

