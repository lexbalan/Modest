
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>


#include <string.h>




// [row, col]
static char *table[5][4] = (char *[5][4]){
	"#", "Header0", "Header1", "Header2",
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};


static void tableSepPrint(uint32_t *sz, int32_t m)
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


static uint32_t max(uint32_t a, uint32_t b)
{
	if (b > a) {
		return b;
	}
	return a;
}


static void tablePrint(char *(*table)[], int32_t n, int32_t m, bool headline)
{
	int32_t i;
	int32_t j;
	uint32_t sz[m];
	memset(&sz, 0, sizeof sz);

	// calculate max length of col
	i = 0;
	while (i < n) {
		j = 0;
		while (j < m) {
			int32_t index = i * (n - 1) + j;
			uint32_t slen = (uint32_t)strlen((*table)[index]);
			sz[j] = max(slen, sz[j]);
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < m) {
		// добавляем 1 пробел слева и один справа
		// для красивого отступа
		sz[i] = sz[i] + 2;
		i = i + 1;
	}

	i = 0;
	while (i < n) {

		// pirint `+----+` separator
		if ((i < 2) || !headline) {
			tableSepPrint(&sz[0], m);
			printf("\n|");
		} else {
			printf("|");
		}

		j = 0;
		while (j < m) {
			int32_t index = i * (n - 1) + j;
			char *s = (*table)[index];
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
	tableSepPrint(&sz[0], m);
	printf("\n");
}


int32_t main()
{
	//
	tablePrint((char *(*)[])&table, 5, 4, true);

	return 0;
}

