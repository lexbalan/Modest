
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


static int32_t main_a0[6] = (int32_t[6]){0, 1, 2, 3, 4, 5};
static int32_t main_a1[2][6] = (int32_t[2][6]){0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5};
static int32_t main_a2[3][6] = (int32_t[3][6]){
	0, 1, 2, 3, 4, 5,
	0, 1, 2, 3, 4, 5,
	0, 1, 2, 3, 4, 5
};
static int32_t main_a3[2][2][6] = (int32_t[2][2][6]){

	0, 1, 2, 3, 4, 5,
	0, 1, 2, 3, 4, 5,

	0, 1, 2, 3, 4, 5,
	0, 1, 2, 3, 4, 5
};

static char *main_data[5][4] = (char *[5][4]){
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word",
	"4", "Xerox", "Yep", "Zn"
};


static char *main_data2[5][4] = (char *[5][4]){
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word",
	"4", "Xerox", "Yep", "Zn"
};


int32_t main()
{
	printf("lengthof(a0) = %lu\n", __lengthof(main_a0));
	printf("sizeof(a0) = %lu\n", sizeof main_a0);

	//printf("lengthof(a0[0]) = %lu\n", lengthof(a0[0]))
	printf("sizeof(a0[0]) = %lu\n", sizeof main_a0[0]);

	printf("\n");

	printf("lengthof(a1) = %lu\n", __lengthof(main_a1));
	printf("sizeof(a1) = %lu\n", sizeof main_a1);

	printf("lengthof(a1[0]) = %lu\n", __lengthof(main_a1[0]));
	printf("sizeof(a1[0]) = %lu\n", sizeof main_a1[0]);
	printf("sizeof(a1[0][0]) = %lu\n", sizeof main_a1[0][0]);

	printf("\n");

	printf("lengthof(a2) = %lu\n", __lengthof(main_a2));
	printf("sizeof(a2) = %lu\n", sizeof main_a2);

	printf("\n");

	printf("lengthof(a3) = %lu\n", __lengthof(main_a3));
	printf("lengthof(a3[0]) = %lu\n", __lengthof(main_a3[0]));
	printf("lengthof(a3[0][0]) = %lu\n", __lengthof(main_a3[0][0]));
	printf("sizeof(a3) = %lu\n", sizeof main_a3);

	//
	printf("\n");

	printf("sizeof(data) = %lu\n", sizeof main_data);
	printf("sizeof(data[0]) = %lu\n", sizeof main_data[0]);
	printf("lengthof(data) = %lu\n", __lengthof(main_data));
	printf("lengthof(data[0]) = %lu\n", __lengthof(main_data[0]));

	printf("\n");

	printf("sizeof(data2) = %lu\n", sizeof main_data2);
	printf("sizeof(data2[0]) = %lu\n", sizeof main_data2[0]);
	printf("lengthof(data2) = %lu\n", __lengthof(main_data2));
	printf("lengthof(data2[0]) = %lu\n", __lengthof(main_data2[0]));

	//print2DArray(&data, 5, 4)
	return 0;
}

