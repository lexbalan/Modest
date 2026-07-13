import "builtin"
include "ctypes64"
include "stdio"

include "libc/ctypes64"
include "libc/stdio"


// 1. Вариантный тип это ОТДЕЛЬНЫЙ ТИП
// 2. Он конструируется неявно только из значений с non-generic типом (входящим в тип-вариант)
// 3. Тег (число) равен позиционному номеру субтипа в записи вариантного типа


type Error = @branded Nat32
const errorNone = Error 0
const errorSome = Error 1


func foo () -> Int or Error {
	return Int 0
	return errorNone
}


@nonstatic
func main () -> Int {
	var x: Int or Error = foo()
	return 0
}

