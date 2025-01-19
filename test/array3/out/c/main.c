
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>


#include <string.h>




#define size_m  3
#define size_n  3
#define size_p  3

static int32_t a[size_m][size_n][size_p] = (int32_t[size_m][size_n][size_p]){

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

static int32_t *b[size_m][size_n] = (int32_t *[size_m][size_n]){

	&a[0][0],
	&a[0][1],
	&a[0][2],


	&a[1][0],
	&a[1][1],
	&a[1][2],


	&a[2][0],
	&a[2][1],
	&a[2][2]
};


static void test0()
{
	printf("test0:\n");
	printf("sizeof(a) = %d\n", (int32_t)sizeof a);
	int32_t i = 0;
	while (i < size_m) {
		int32_t j = 0;
		while (j < size_n) {
			int32_t k = 0;
			while (k < size_p) {
				int32_t v = a[i][j][k];
				printf("a[%d][%d][%d] = %d\n", i, j, k, v);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}


static void test1(int32_t(*pa)[], int32_t m, int32_t n, int32_t p)
{
	printf("test1:\n");

	int32_t(*pa2)[m][n][p] = (int32_t(*)[m][n][p])pa;

	//var local = *pa2

	printf("sizeof(pa2) = %d\n", (int32_t)sizeof pa2);
	printf("sizeof(*pa2) = %d\n", sizeof *pa2);

	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			int32_t k = 0;
			while (k < p) {
				int32_t v = (*pa2)[i][j][k];
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}


static void test2(int32_t *(*pb)[], int32_t m, int32_t n, int32_t p)
{
	printf("test2:\n");

	int32_t *(*pa2)[m][n] = (int32_t *(*)[m][n])pb;

	printf("sizeof(pa2) = %d\n", (int32_t)sizeof pa2);
	printf("sizeof(*pa2) = %d\n", sizeof *pa2);

	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			int32_t k = 0;
			while (k < p) {
				int32_t v = (*pa2)[i][j][k];
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}



static void checkLocal3DArray()
{
	int32_t a = 10;
	int32_t b = 10;
	int32_t c = 10;

	// create VLA
	int32_t x[a][b][c];
	memset(&x, 0, sizeof x);

	// Write
	int32_t i = 0;
	while (i < a) {
		int32_t j = 0;
		while (j < b) {
			int32_t k = 0;
			while (k < c) {
				x[i][j][k] = i * j * k;
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	// Read
	i = 0;
	while (i < a) {
		int32_t j = 0;
		while (j < b) {
			int32_t k = 0;
			while (k < c) {
				int32_t v = x[i][j][k];
				printf("x[%d][%d][%d] = %d ", i, j, k, v);

				if (v == i * j * k) {
					printf("OK\n");
				} else {
					printf("ERROR\n");
				}

				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}

int32_t main()
{
	test0();
	test1((void *)&a, size_m, size_n, size_p);
	test2((void *)&b, size_m, size_n, size_p);

	checkLocal3DArray();
	return 0;
}

