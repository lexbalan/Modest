
include "libc/ctypes64"
include "libc/stdio"


type Point record {
	x: Nat32
	y: Nat32
}
let genericIntConst = 42
let int32Const = Int32 genericIntConst
let genericStringConst = "Hello!"
let string8Const = *Str8 genericStringConst
let string16Const = *Str16 genericStringConst
let string32Const = *Str32 genericStringConst
let ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]
let points = [3]Point ps
var points2: [3]Point = points
func main() -> Int {
	printf("test const\n")

	printf("genericIntConst = %d\n", Int32 genericIntConst)
	printf("int32Const = %d\n", int32Const)

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const)

	return 0
}

