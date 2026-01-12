// examples/0.endianness/src/main.m

module "ct_call/main"

include "libc/ctypes64"
include "libc/stdio"


func sum (a: Int32, b: Int32) -> Int32 {
	return a + b
}

const s = sum(1, 2)

func arr () -> [3]Int32 {
	return [1, 2, 3]
}

const a = arr()



public func main () -> Int {
	printf("compile time call implementation test\n")
	return 0
}

