// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



static int32_t a0[2 * 2 * 5] = (int32_t[2 * 2 * 5]){

	0, 1, 2, 3, 4,
	5, 6, 7, 8, 9,


	10, 11, 12, 13, 14,
	15, 16, 17, 18, 19
};

static int32_t a1[5] = (int32_t[5]){0, 1, 2, 3, 4};
static int32_t a2[5] = (int32_t[5]){5, 6, 7, 8, 9};
static int32_t *a3[2] = (int32_t *[2]){&a1[0], &a2[0]};
static int32_t *(*a4[2])[2] = (int32_t *(*[2])[2]){&a3, &a3};

int32_t main()
{
	int32_t i;
	int32_t j;
	int32_t k;

	//printf("x = %d ", a0[i][j])

	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i * 2 * 5 + j * 5 + k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
	//
	//
	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 5) {
			printf("a3[%d][%d] = %d\n", i, j, a3[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}

	printf("x = %d\n", a0[0 * 2 * 5 + 1 * 5 + 2]);
	printf("x = %d\n", a3[1][4]);


	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, (*a4[i])[j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	return 0;
}

