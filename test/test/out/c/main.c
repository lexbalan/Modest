
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>


#include <string.h>



//@property("type.generic", true)

static int32_t a[2][3] = (int32_t[2][3]){
	1, 2, 3,
	4, 5, 6
};


static void print2DArray(int32_t(*pa)[], int32_t m, int32_t n)
{
	//let pg = *[m][n]Int32 pa
	int32_t gg[m][n];
	memset(&gg, 0, sizeof gg);
	int32_t(*pg)[m][n] = (int32_t(*)[m][n])pa;
	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			printf("pa[%i][%i] = %i\n", i, j, (*pg)[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}
}


static void foo(int32_t x, int32_t y)
{
	printf("foo(%d, %d)\n", x, y);
}


//$pragma insert "// text insertion"

int32_t main()
{
	int32_t(*pa)[];
	pa = (void *)&a;

	print2DArray((void *)&a, 2, 3);

	foo(1, 2);

	return 0;
}

