
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

const points = [<str_value>]Point ps


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
var points2: [<str_value>]Point = points


// define function main
public func main() -> Int {
	stdio.("test const\n")

	stdio.("genericIntConst = %d\n", Int32 genericIntConst)
	stdio.("int32Const = %d\n", int32Const)

	//	printf("genericStringConst = %s\n", genericStringConst)
	stdio.("string8Const = %s\n", string8Const)

	return 0
}

