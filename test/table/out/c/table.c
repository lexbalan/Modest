
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "table.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>





// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions

static void table_printSep(uint32_t *sz, uint32_t m);
static void table_printRow(char *(*raw_row)[], uint32_t *sz, uint32_t ncols);
void table_print(table_Table *table)
{
	uint32_t i;
	uint32_t j;

	uint32_t rows = table->rows;
	uint32_t cols = table->cols;
	// construct pointer to closed VLA array
	char *(*table_data)[rows][cols] = (char *(*)[rows][cols])table->data;

	// array of size of columns (in characters)
	uint32_t sz[cols];
	memset(&sz, 0, sizeof sz);

	// calculate max length (in chars) of column

	if (table->header != NULL) {
		i = 0;
		while (i < cols) {
			char *str = (*table->header)[i];
			uint32_t len = (uint32_t)strlen(str);
			if (len > sz[i]) {
				sz[i] = len;
			}
			i = i + 1;
		}
	}

	i = 0;
	while (i < table->rows) {
		j = 0;
		while (j < table->cols) {
			char *str = (*table_data)[i][j];
			uint32_t len = (uint32_t)strlen(str);
			if (len > sz[j]) {
				sz[j] = len;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < table->cols) {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2;
		i = i + 1;
	}

	// top border
	table_printSep((uint32_t *)&sz, table->cols);

	if (table->header != NULL) {
		table_printRow(table->header, (uint32_t *)&sz, table->cols);
		table_printSep((uint32_t *)&sz, table->cols);
	}

	i = 0;
	while (i < table->rows) {
		table_printRow(&(*table_data)[i], (uint32_t *)&sz, table->cols);
		i = i + 1;

		// print `+--+--+` separator line
		if (table->separate && i < table->rows) {
			table_printSep((uint32_t *)&sz, table->cols);
		}
	}

	// bottom border
	table_printSep((uint32_t *)&sz, table->cols);
}


static void table_printRow(char *(*raw_row)[], uint32_t *sz, uint32_t ncols)
{
	char *(*row)[ncols] = (char *(*)[ncols])raw_row;

	uint32_t j = 0;
	while (j < ncols) {
		printf("|");
		char *s = (*row)[j];
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
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
static void table_printSep(uint32_t *sz, uint32_t m)
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
	printf("+\n");
}

