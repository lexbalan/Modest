
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>

#include <stdlib.h>

#include <string.h>



// [row, col]
#define main_nRows  5
#define main_nCols  4
static char *main_table[5][4] = (char *[5][4]){
	"#", "Header0", "Header1", "Header2",
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};


static uint32_t main_max(uint32_t a, uint32_t b)
{
	if (b > a) {
		return b;
	}
	return a;
}


static void main_tableSepPrint(uint32_t *sz, int32_t m)
{
	printf("+");
	int32_t i = 0;
	while (i < m) {
		uint32_t j = 0;
		while (j < sz[i]) {
			printf("-");
			j = j + 1;
		}
		printf("+");
		i = i + 1;
	}
}

// we cannot receive VLA by value,
// but we can to receive pointer to open array
// and after construct pointer to closed array with required dimensions
static void main_tablePrint(char *(*tablex)[], int32_t m, int32_t n, bool headline)
{
	int32_t i;
	int32_t j;

	// array of size of columns (in characters)
	uint32_t sz[n];
	memset(&sz, 0, sizeof sz);

	// construct pointer to closed array
	char *(*table)[m][n] = (char *(*)[m][n])tablex;

	// calculate max length (in chars) of column
	i = 0;
	while (i < m) {
		j = 0;
		while (j < n) {
			uint32_t slen = (uint32_t)strlen((*table)[i][j]);
			sz[j] = main_max(slen, sz[j]);
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < n) {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2;
		i = i + 1;
	}

	i = 0;
	while (i < m) {
		// pirint `+----+` separator
		if (i < 2 || !headline) {
			main_tableSepPrint((uint32_t *)&sz, n);
			printf("\n");
		}

		printf("|");

		j = 0;
		while (j < n) {
			char *s = (*table)[i][j];
			uint32_t len = (uint32_t)strlen(s);
			if (s[0] != '\x0') {
				len = len + 1;
				printf(" %s", s);
			}

			uint32_t k = 0;
			while (k < sz[j] - len) {
				printf(" ");
				k = k + 1;
			}

			printf("|");
			j = j + 1;
		}
		printf("\n");
		i = i + 1;
	}
	main_tableSepPrint((uint32_t *)&sz, n);
	printf("\n");
}


int32_t main()
{
	main_tablePrint((void *)&main_table, main_nRows, main_nCols, true);
	return 0;
}

