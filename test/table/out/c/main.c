
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>
#include <stdlib.h>
#include <string.h>



static char *main_table0[3][3] = (char *[3][3]){
	"#", "Header0", "Header1",
	"0", "Alef", "Betha",
	"1", "Clock", "Depth"
};

static char *main_table1[5][4] = (char *[5][4]){
	"#", "Header0", "Header1", "Header2",
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions

static void main_printTableSep(uint32_t *sz, uint32_t m);
static void main_tablePrint(char *(*tablex)[], uint32_t m, uint32_t n, bool headline)
{
	uint32_t i;
	uint32_t j;

	// construct pointer to closed array
	char *(*table)[m][n] = (char *(*)[m][n])tablex;

	// array of size of columns (in characters)
	uint32_t sz[n];
	memset(&sz, 0, sizeof sz);

	// calculate max length (in chars) of column
	i = 0;
	while (i < m) {
		j = 0;
		while (j < n) {
			char *str = (*table)[i][j];
			uint32_t len = (uint32_t)strlen(str);
			if (len > sz[j]) {
				sz[j] = len;
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
		// pirint `+--+--+` separator line
		if (i < 2 || !headline) {
			main_printTableSep((uint32_t *)&sz, n);
			printf("\n");
		}

		j = 0;
		while (j < n) {
			printf("|");
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
			j = j + 1;
		}
		printf("|\n");
		i = i + 1;
	}
	main_printTableSep((uint32_t *)&sz, n);
	printf("\n");
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
static void main_printTableSep(uint32_t *sz, uint32_t m)
{
	uint32_t i = 0;
	while (i < m) {
		printf("+");
		uint32_t j = 0;
		while (j < sz[i]) {
			printf("-");
			j = j + 1;
		}
		i = i + 1;
	}
	printf("+");
}


int32_t main()
{
	printf("sizeof(table0) = %d\n", (uint32_t)sizeof main_table0);
	printf("sizeof(table1) = %d\n", (uint32_t)sizeof main_table1);

	main_tablePrint((void *)&main_table0, LENGTHOF(main_table0), LENGTHOF(main_table0[0]), false);
	main_tablePrint((void *)&main_table1, LENGTHOF(main_table1), LENGTHOF(main_table1[0]), true);

	return 0;
}

