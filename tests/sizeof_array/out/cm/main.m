
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


var data: [5][4]*[]Char8 = [
	["0", "Alef", "Betha", "Emma"]
	["1", "Clock", "Depth", "Free"]
	["2", "Ink", "Julia", "Keyword"]
	["3", "Ultra", "Video", "Word"]
	["4", "Xerox", "Yep", "Zn"]
]


func f2(pa: *[][]*Str8, m: Int32, n: Int32) -> Unit {
	let pg = *[m][n]*ctypes64.Str pa
	let ph = &(pg[3])
	let pk = &(pg[4])
	stdio.printf("ph[0] = %s\n", ph[1])
	stdio.printf("pk[0] = %s\n", pk[1])
}


func print2DArray(pa: *[][]*Str8, m: Int32, n: Int32) -> Unit {
	let pg = *[m][n]*ctypes64.Str pa
	var i: Int32 = 0
	while i < m {
		var j: Int32 = 0
		while j < n {
			stdio.printf("pa[%i][%i] = %s\n", i, j, pg[i][j])
			j = j + 1
		}
		i = i + 1
	}
}


public func main() -> Int32 {
	f2(&data, 5, 4)

	stdio.printf("sizeof(data) = %lu\n", sizeof data)
	stdio.printf("sizeof(data[0]) = %lu\n", sizeof data[0])

	stdio.printf("lengthof(data) = %lu\n", lengthof(data))
	stdio.printf("lengthof(data[0]) = %lu\n", lengthof(data[0]))


	//print2DArray(&data, 5, 4)
	return 0
}

