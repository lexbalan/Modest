// examples/annotations/src/main.m

include "libc/ctypes64"
include "libc/stdio"


type MyInt32 = @distinct Int32
@calias("MY_ZERO")
const myZero = MyInt32 0
@calias("MY_ONE")
const myOne = MyInt32 1


// These refined MyInt32 types are compatible with MyInt32
// but not compatible with anything else (e.g. between them)
type MyInt32_2 = MyInt32
type MyInt32_3 = MyInt32


const cvb = @volatile Int32 0
var vvb = @volatile Int32 1


type ProtocolHeader = @packed record {
	start: Word16
	len: Nat16
}

@alias("name2")
var name1: Bool

@calias("name22")
var name11: Bool

@extern
var ext: Int32

@extern
var ext_arr: []Int32

@alignment(8)
@section("__DATA, .xdata")
var x: Word32


@nonstatic
var s: Nat16

@used
var u: Word64

@unused
var u2: Word64


@nodecorate
public const const0 = 0


var rp: @restrict *Word32
var vb: @volatile [32]Bool



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


type Point2D = record {
	x: Float64 = 0
	y: Float64 = 0
}



// переопределение f не вызвало ошибку!
//@conditional(const1 < const2)
func hello () -> Unit {
	printf("hi!\n")
}




public func main () -> Int32 {
	hello()
	printf("Attributes example\n")
	Unit staticInlineFunc(0)
	Unit staticNoinlineFunc(0)
	Unit staticInlineHintFunc(0)
	return 0
}


