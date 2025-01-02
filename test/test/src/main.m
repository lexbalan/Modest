
include "libc/stdio"


var a0: [2][2][5]Int32 = [
	[
		[0, 1, 2, 3, 4]
		[5, 6, 7, 8, 9]
	]

	[
		[10, 11, 12, 13, 14]
		[15, 16, 17, 18, 19]
	]
]


var a1: [5]Int32 = [0, 1, 2, 3, 4]
var a2: [5]Int32 = [5, 6, 7, 8, 9]

var a3: [2]*[5]Int32 = [&a1, &a2]


public func main() -> Int32 {
	var i, j, k: Int32

	//printf("x = %d ", a0[i][j])

//	i = 0
//	while i < 2 {
//		j = 0
//		while j < 2 {
//			k = 0
//			while k < 5 {
//				printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i][j][k])
//				++k
//			}
//			++j
//		}
//		++i
//	}
//
//
//	i = 0
//	while i < 2 {
//		j = 0
//		while j < 5 {
//			printf("a3[%d][%d] = %d\n", i, j, a3[i][j])
//			++j
//		}
//		++i
//	}

	printf("x = %d\n", a0[0][1][2])
	//printf("x = %d\n", a3[0][1])

	return 0
}
