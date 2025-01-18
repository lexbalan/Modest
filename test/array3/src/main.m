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
	var i = 0
	while i < m {
		var j = 0
		while j < n {
			var k = 0
			while k < p {
				let v = (*[m][n][p]Int32 pa)[i][j][k]
				printf("pa[%d][%d][%d] = %d\n", i, j, k, v)
				++k
			}
			++j
		}
		++i
	}
}


public func main() -> Int32 {
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

	return 0
}


