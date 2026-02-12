include "ctypes64"
include "stdio"



func sum (a: Int32, b: Int32) -> Int32 {
	return a + b
}

const s: Int32 = sum(1, 2)

func arr () -> [3]Int32 {
	return [1, 2, 3]
}

const a: [3]Int32 = arr()



public func main () -> Int {
	printf("compile time call implementation test\n")
	return 0
}

