// tests/3.const/src/main.m

include "libc/ctypes64"
include "libc/stdio"

const genericIntConst = 42
const int32Const = Int32 genericIntConst

const genericStringConst = "Hello!"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst


type Point = record {
	x: Nat32
	y: Nat32
}


const ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]

const points = [3]Point ps

@used
var points2 = points


// define function main
public func main () -> Int {
	printf("test const\n")

	printf("genericIntConst = %d\n", Int32 genericIntConst)
	printf("int32Const = %d\n", int32Const)

//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const)

	return 0
}


