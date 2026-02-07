include "ctypes64"
include "stdio"



// Not implemented in LLVM (!)
type Union1 = @union record {
	_int: Int64
	_float: Float64
}



@used
var u1: Union1


public func main () -> Int32 {
	printf("union test\n")

	printf("sizeof(Union1) = %lu\n", sizeof(Union1))
	printf("sizeof(u1) = %lu\n", sizeof u1)
	return 0
}

