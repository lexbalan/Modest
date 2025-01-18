include "libc/stdio"
include "libc/stdlib"
include "libc/string"

//@property("type.generic", true)

var a: [2][2][3]Int32 = [
	[
		[1, 2, 3]
		[4, 5, 6]
	]
	[
		[7, 8, 9]
		[10, 11, 12]
	]
]


func print3DArray(pa: *[][][]Int32, m: Int32, n: Int32, p: Int32) {
	//let pg: *[m][n][p]Int32 = *[m][n][p]Int32 pa
	let pg = *[m][n][p]Int32 pa
	var i = 0
	while i < m {
		var j = 0
		while j < n {
			var k = 0
			while k < p {
				printf("pa[%i][%i][%i] = %i\n", i, j, k, pg[i][j][k])
				++k
			}
			++j
		}
		++i
	}
}


func foo(x: Int32, y: Int32 = 50) {
	printf("foo(%d, %d)\n", x, y)
}


//$pragma insert "// text insertion"

public func main() -> Int32 {
	print3DArray(&a, 2, 2, 3)

	foo(1, 2)

	return 0
}


