private import "builtin"
include "ctypes64"
include "stdio"


type NewInt32 = Int32

public func main () -> Int {
	printf("test typedef\n")

	var newInt32: NewInt32
	newInt32 = NewInt32 0
	Unit newInt32

	return 0
}

