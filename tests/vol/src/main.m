// tests/0/src/main.m

//include "libc/ctypes64"
//include "libc/stdio"

// При создании переменной на базе значения, если его тип имеет атрибут const
// const отбрасывается в новом типе (типе самой переменной)
var x = Str8 "sss"
var y = @volatile Nat32 0

func main () -> Int32 {
	return 0
}

