include "ctypes64"
include "stdio"
// tests/4.typedef/src/main.m

type NewInt32 = Int32

public func main () -> Int {
	printf("test typedef\n")

	var newInt32: NewInt32
	newInt32 = NewInt32 0
	Unit newInt32

	//type NewInt16 Int16
	//var newInt16: NewInt16
	//newInt16 = NewInt16 0

	return 0
}

