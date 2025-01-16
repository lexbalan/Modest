include "libc/stdio"
include "libc/stdlib"
include "libc/string"

//@property("type.generic", true)

var a: [2][3]Int32 = [
	[1, 2, 3]
	[4, 5, 6]
]


func print2DArray(pa: *[][]Int32, m: Int32, n: Int32) {
	//let pg = *[m][n]Int32 pa
	let gg: [m][n]Int32 = []

	let pg: *[m][n]Int32 = *[m][n]Int32 pa
	var i = 0
	while i < m {
		var j = 0
		while j < n {
			printf("pa[%i][%i] = %i\n", i, j, pg[i][j])
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
	var pa: *[][]Int32
	pa = &a

	print2DArray(&a, 2, 3)

	foo(1, 2)

	return 0
}


