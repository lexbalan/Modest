// tests/0/src/main.m

//include "libc/ctypes64"
//include "libc/stdio"

// У переменной x будет тип Nat32 без атрибута volatile
// поскольку происходит reborn типа который сбрасывает все флаги и атрибуты
var x = @volatile Nat32 0

public func main () -> Int32 {
	return 0
}

