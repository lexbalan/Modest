include "libc/stdio"
include "libc/stdlib"
include "libc/string"


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

var b: [m][n]*[p]Int32 = [
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

//
//func test() {
//	printf("test:\n")
//
//	var i = 0
//	while i < m {
//		var j = 0
//		while j < n {
//			var k = 0
//			while k < p {
//				let pa = unsafe *[]Int32 &a
//				//let v = a[i][j][k]
//				// не умножаем на sizeof(Int32), тк здесь все идет в sizeof(Int32)
//				let pk = 1  // здесь за единицу принят sizeof(Int32)
//				let pj = m * pk
//				let pi = n * pj
//				let v = pa[i*pi + j*pj + k*pk]
//				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
//				++k
//			}
//			++j
//		}
//		++i
//	}
//}






func test2(pa: *[][][]Int32, m: Int32, n: Int32, p: Int32) {
	printf("test2:\n")

	let pa2 = *[m][n][p]Int32 pa

	printf("sizeof(pa2) = %d\n", Int32 sizeof(pa2))
	printf("sizeof(*pa2) = %d\n", sizeof(*pa2))

	var i = 0
	while i < m {
		var j = 0
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

func test3(pa: *[][]*[]Int32, m: Int32, n: Int32, p: Int32) {
	printf("test3:\n")

	let pa2 = *[m][n]*[p]Int32 pa

	printf("sizeof(pa2) = %d\n", Int32 sizeof(pa2))
	printf("sizeof(*pa2) = %d\n", sizeof(*pa2))

	var i = 0
	while i < m {
		var j = 0
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


public func main() -> Int32 {
	printf("sizeof(a) = %d\n", unsafe Int32 sizeof(a))

	var i = 0
	while i < m {
		var j = 0
		while j < n {
			var k = 0
			while k < p {
				let v = a[i][j][k]
				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
				++k
			}
			++j
		}
		++i
	}

	//test()

	test2(&a, m, n, p)
	test3(&b, m, n, p)

	return 0
}


