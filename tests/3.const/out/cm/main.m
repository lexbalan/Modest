
@c_include "stdio.h"

const genericIntConst = 42
const int32Const = Int32 genericIntConst

const genericStringConst = "Hello!"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst


type Point record {
	x: Nat32
	y: Nat32
}


const ps = [
	{x = 0, y = 0}
	{x = 1, y = 1}
	{x = 2, y = 2}
]

const points = [3]Point ps


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
var points2: [3]Point = points


// define function main
public func main() -> ctypes64.Int {
	stdio.printf("test const\n")

	stdio.printf("genericIntConst = %d\n", Int32 genericIntConst)
	stdio.printf("int32Const = %d\n", int32Const)

	//	printf("genericStringConst = %s\n", genericStringConst)
	stdio.printf("string8Const = %s\n", string8Const)

	return 0
}

