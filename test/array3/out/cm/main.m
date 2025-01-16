
@c_include "stdio.h"
include "libc/stdio"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "string.h"
include "libc/string"

//@property("type.generic", true)

const m = 3
const n = 3
const p = 3
var a: [m][n][p]Int32 = [
	[
		[1, 2, 3]
		[4, 5, 6]
		[7, 8, 9]
	]

	[
		[11, 12, 13]
		[14, 15, 16]
		[17, 18, 19]
	]

	[
		[21, 22, 23]
		[24, 25, 26]
		[27, 28, 29]
	]
]


//func p(pa: *[][]Int32) {
//	var a = 2
//	var b = 3
//	let pg = *[a][b]Int32 pa
//	printf("pa[0][0] = %i\n", pg[1][0])
//}


//$pragma insert "// text insertion"

public func main() -> Int32 {

	var i: Int32 = 0
	while i < m {
		var j: Int32 = 0
		while j < n {
			var k: Int32 = 0
			while k < p {
				let v = ((a[i])[j])[k]
				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}

	return 0
}

