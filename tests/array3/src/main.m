include "libc/stdio"
include "libc/stdlib"
include "libc/string"


const size_m = 3
const size_n = 3
const size_p = 3

var a: [size_m][size_n][size_p]Int32 = [
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

var b: [size_m][size_n]*[size_p]Int32 = [
	[
		&a[0][0]
		&a[0][1]
		&a[0][2]
	]

	[
		&a[1][0]
		&a[1][1]
		&a[1][2]
	]

	[
		&a[2][0]
		&a[2][1]
		&a[2][2]
	]
]


func test0() {
	printf("test0:\n")
	printf("sizeof(a) = %d\n", unsafe Int32 sizeof(a))
	var i: Nat32 = 0
	while i < size_m {
		var j: Nat32 = 0
		while j < size_n {
			var k = 0
			while k < size_p {
				let v = a[i][j][k]
				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
				++k
			}
			++j
		}
		++i
	}
}


func test1(pa: *[][][]Int32, m: Int32, n: Int32, p: Int32) {
	printf("test1:\n")

	let pa2 = *[m][n][p]Int32 pa

	//var local = *pa2

	printf("sizeof(pa2) = %d\n", Int32 sizeof(pa2))
	printf("sizeof(*pa2) = %d\n", sizeof(*pa2))

	var i: Nat32 = 0
	while i < m {
		var j: Nat32 = 0
		while j < n {
			var k = 0
			while k < p {
				let v = pa2[i][j][k]
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v)
				++k
			}
			++j
		}
		++i
	}
}


func test2(pb: *[][]*[]Int32, m: Int32, n: Int32, p: Int32) {
	printf("test2:\n")

	let pa2 = *[m][n]*[p]Int32 pb

	printf("sizeof(pa2) = %d\n", Int32 sizeof(pa2))
	printf("sizeof(*pa2) = %d\n", sizeof(*pa2))

	printf("sizeof([m][n]*[p]Int32) = %d\n", sizeof([m][n]*[p]Int32))

	var i: Nat32 = 0
	while i < m {
		var j: Nat32 = 0
		while j < n {
			var k = 0
			while k < p {
				let v = pa2[i][j][k]
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v)
				++k
			}
			++j
		}
		++i
	}
}



func checkLocal3DArray() {
	var a = Int32 10
	var b = Int32 10
	var c = Int32 10

	// create VLA
	var x: [a][b][c]Int32

	// Write
	var i: Nat32 = 0
	while i < a {
		var j: Nat32 = 0
		while j < b {
			var k = 0
			while k < c {
				x[i][j][k] = i*j*k
				++k
			}
			++j
		}
		++i
	}

	// Read
	i = 0
	while i < a {
		var j: Nat32 = 0
		while j < b {
			var k = 0
			while k < c {
				let v = x[i][j][k]
				printf("x[%d][%d][%d] = %d ", i, j, k, v)

				if v == i*j*k {
					printf("OK\n")
				} else {
					printf("ERROR\n")
				}

				++k
			}
			++j
		}
		++i
	}
}

public func main() -> Int32 {
	test0()
	test1(&a, size_m, size_n, size_p)
	test2(&b, size_m, size_n, size_p)

	//checkLocal3DArray()
	return 0
}


