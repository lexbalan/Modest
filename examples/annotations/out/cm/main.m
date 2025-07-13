include "ctypes64"
include "stdio"
// examples/annotations/src/main.m


type MyInt32 = Int32

const myZero = MyInt32 0

const myOne = MyInt32 1


// These refined MyInt32 types are compatible with MyInt32
// but not compatible with anything else (e.g. between them)
type MyInt32_2 = MyInt32
type MyInt32_3 = MyInt32


const cvb: Bool = true
var vvb: Bool = true


type ProtocolHeader = @packed record {
	start: Word16
	len: Nat16
}


var name2: Bool


var name11: Bool


@extern
var ext: Int32



@section("__DATA, .xdata")
@alignment(8)
var x: Word32



var s: Nat16


@used
var u: Word64


@unused
var u2: Word64



public const const0 = 0


var rp: *Word32
var vb: []Bool


func boolFunction (x: Bool) -> Bool {
	if x {
		return true
	} else {
		return false
	}
	return false
}



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
	x: Float64
	y: Float64
}


public func main () -> Int {
	printf("Attributes example\n")
	return 0
}

