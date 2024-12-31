
@c_include "stdio.h"
include "libc/stdio"


var a0: [5]Int32 = [0, 1, 2, 3, 4]
var a1: [5]Int32 = [5, 6, 7, 8, 9]

var a2: [2][2][5]Int32 = [
	[
		[0, 1, 2, 3, 4]
		[5, 6, 7, 8, 9]
	]

	[
		[10, 11, 12, 13, 14]
		[15, 16, 17, 18, 19]
	]
]

public func main() -> Int32 {
	let x = a2[1][1][2]
	printf("x = %d\n", x)

	return 0
}

