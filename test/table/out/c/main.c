
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// [row, col]
#define main_nRows0  3
#define main_nCols0  3
static char *main_table0[3][3] = (char *[3][3]){
	"#", "Header0", "Header1",
	"0", "Alef", "Betha",
	"1", "Clock", "Depth"
};


#define main_nRows1  5
#define main_nCols1  4
static char *main_table1[5][4] = (char *[5][4]){
	"#", "Header0", "Header1", "Header2",
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
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
// but we can receive pointer to open array
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
			if (slen > sz[j]) {
				sz[j] = slen;
			}
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
	main_tablePrint((void *)&main_table0, LENGTHOF(main_table0), LENGTHOF(main_table0[0]), true);
	main_tablePrint((void *)&main_table1, LENGTHOF(main_table1), LENGTHOF(main_table1[0]), true);
	return 0;
}

