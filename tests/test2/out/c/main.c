
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


static char *main_data[5][4] = (char *[5][4]){
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word",
	"4", "Xerox", "Yep", "Zn"
};


static void main_f2(char *(*pa)[], int32_t m, int32_t n)
{
	char *(*const pg)[m][n] = (char *(*)[m][n])pa;
	char *(*const ph)[n] = &(*pg)[3];
	char *(*const pk)[n] = &(*pg)[4];
	printf("ph[0] = %s\n", (*ph)[1]);
	printf("pk[0] = %s\n", (*pk)[1]);
}


static void main_print2DArray(char *(*pa)[], int32_t m, int32_t n)
{
	char *(*const pg)[m][n] = (char *(*)[m][n])pa;
	int32_t i = 0;
	while (i < m) {
		int32_t j = 0;
		while (j < n) {
			printf("pa[%i][%i] = %s\n", i, j, (*pg)[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}
}


int32_t main()
{
	main_f2((void *)&main_data, 5, 4);

	printf("sizeof(data) = %lu\n", sizeof main_data);
	printf("sizeof(data[0]) = %lu\n", sizeof main_data[0]);

	printf("lengthof(data) = %lu\n", LENGTHOF(main_data));
	printf("lengthof(data[0]) = %lu\n", LENGTHOF(main_data[0]));


	//print2DArray(&data, 5, 4)
	return 0;
}

