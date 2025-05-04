
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"


static int32_t a[2][2][3] = {

	1, 2, 3,
	4, 5, 6,

	7, 8, 9,
	10, 11, 12
};

static void print3DArray(int32_t(*pa)[], int32_t m, int32_t n, int32_t p)
{
	//let pg: *[m][n][p]Int32 = *[m][n][p]Int32 pa
	int32_t(*const pg)[m][n][p] = (int32_t(*)[m][n][p])pa;
	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			int32_t k = 0;
			while (k < p) {
				printf("pa[%i][%i][%i] = %i\n", i, j, k, (*pg)[i][j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}

static void foo(int32_t x, int32_t y)
{
	printf("foo(%d, %d)\n", x, y);
}

static volatile int32_t f;
static int32_t *p;

int32_t main()
{
	print3DArray((void *)&a, 2, 2, 3);

	foo(1, 2);

	return 0;
}

