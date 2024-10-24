// test/3.const/src/main.cm

include "libc/ctypes64"
include "libc/stdio"

let genericIntConst = 42
let int32Const = Int32 genericIntConst

let genericStringConst = "Hello!"
let string8Const = *Str8 genericStringConst
let string16Const = *Str16 genericStringConst
let string32Const = *Str32 genericStringConst


type Point record {
	x: Nat32
	y: Nat32
}


let ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]

let points = [3]Point ps


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
var points2 = points


// define function main
public func main() -> Int {
	printf("test const\n")

	printf("genericIntConst = %d\n", Int32 genericIntConst)
	printf("int32Const = %d\n", int32Const)

//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const)

	return 0
}


