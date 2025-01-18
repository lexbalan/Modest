
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>


#include <string.h>




#define m  3
#define n  3
#define p  3

static int32_t a[m][n][p] = (int32_t[m][n][p]){

	1, 2, 3,
	4, 5, 6,
	7, 8, 9,


	11, 12, 13,
	14, 15, 16,
	17, 18, 19,


	21, 22, 23,
	24, 25, 26,
	27, 28, 29
};

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



static void test2(int32_t(*pa)[], int32_t m, int32_t n, int32_t p)
{
	printf("test2:\n");

	int32_t(*a)[m][n][p] = (int32_t(*)[m][n][p])pa;
	printf("sizeof(a2) = %d\n", (int32_t)sizeof a);

	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			int32_t k = 0;
			while (k < p) {
				int32_t v = (*a)[i][j][k];
				printf("pa[%d][%d][%d] = %d\n", i, j, k, v);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}


int32_t main()
{

	printf("sizeof(a) = %d\n", (int32_t)sizeof a);

	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			int32_t k = 0;
			while (k < p) {
				int32_t v = a[i][j][k];
				printf("a[%d][%d][%d] = %d\n", i, j, k, v);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	//test()

	test2((void *)&a, m, n, p);

	return 0;
}

