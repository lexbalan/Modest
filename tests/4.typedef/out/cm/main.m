include "ctypes64"
include "stdio"


type NewInt32 Int32

public func main() -> Int {
	stdio.printf("test typedef\n")

	var newInt32: NewInt32
	newInt32 = NewInt32 0

	//type NewInt16 Int16
	//var newInt16: NewInt16
	//newInt16 = NewInt16 0

	return 0
}

