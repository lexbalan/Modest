
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"

//@set("type.generic", true)

static int32_t main_a[2][2][3] = (int32_t[2][2][3]){

	1, 2, 3,
	4, 5, 6,

	7, 8, 9,
	10, 11, 12
};


static void main_print3DArray(int32_t(*pa)[], int32_t m, int32_t n, int32_t p)
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


static void main_foo(int32_t x, int32_t y)
{
	printf("foo(%d, %d)\n", x, y);
}


//$pragma insert "// text insertion"


static volatile int32_t main_f;


static int32_t *volatile main_p;

int32_t main()
{
	main_print3DArray((void *)&main_a, 2, 2, 3);

	main_foo(1, 2);

	return 0;
}

