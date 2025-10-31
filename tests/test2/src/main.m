include "libc/stdio"
include "libc/stdlib"
include "libc/string"


type Dat record {
	a: Nat8
	b: Nat32
}

var xxx: []Dat = [
	{a=0, b=1}
	{a=2, b=3}
	{a=4, b=5}
]

var data: [][]*Str8 = [
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
	["4", "Xerox",   "Yep",     "Zn"]
]


func f2(pa: *[][]*Str8, m: Int32, n: Int32) {
	let pg = *[m][n]*Str pa
	let ph = &pg[3]
	let pk = &pg[4]
	printf("ph[0] = %s\n", ph[1])
	printf("pk[0] = %s\n", pk[1])
}


func print2DArray(pa: *[][]*Str8, m: Int32, n: Int32) {
	let pg = *[m][n]*Str pa
	var i: Nat32 = 0
	while i < m {
		var j: Nat32 = 0
		while j < n {
			printf("pa[%i][%i] = %s\n", i, j, pg[i][j])
			++j
		}
		++i
	}
}


@volatile
var f: Int32

public func main() -> Int32 {
	f2(&data, 5, 4)

	printf("sizeof(data) = %lu\n", sizeof(data))
	printf("sizeof(data[0]) = %lu\n", sizeof(data[0]))

	printf("lengthof(data) = %lu\n", lengthof(data))
	printf("lengthof(data[0]) = %lu\n", lengthof(data[0]))


	//print2DArray(&data, 5, 4)
	return 0
}


