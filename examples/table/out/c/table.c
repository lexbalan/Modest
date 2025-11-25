
#include "table.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions

static void separator(uint32_t *sz, uint32_t n);
static void printRow(char *(*raw_row)[], uint32_t *sz, uint32_t nCols);

void table_print(table_Table *table) {
	uint32_t i;
	uint32_t j;

	// construct pointer to closed VLA array
	char *(*const data)[table->nRows][table->nCols] = (char *(*)[table->nCols])(char *(*)[table->nRows][table->nCols])table->data;

	// array of size of columns (in characters)
	uint32_t sz[table->nCols];
	memset(&sz, 0, sizeof(uint32_t[table->nCols]));

	//
	// calculate max length (in chars) of column
	//

	if (table->header != NULL) {
		i = 0;
		while (i < table->nCols) {
			const uint32_t len = (uint32_t)strlen((*table->header)[i]);
			if (len > sz[i]) {
				sz[i] = len;
			}
			i = i + 1;
		}
	}

	i = 0;
	while (i < table->nRows) {
		j = 0;
		while (j < table->nCols) {
			const uint32_t len = (uint32_t)strlen((*data)[i][j]);
			if (len > sz[j]) {
				sz[j] = len;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < table->nCols) {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2;
		i = i + 1;
	}

	//
	// print table
	//

	// top border
	separator((uint32_t *)&sz, table->nCols);

	if (table->header != NULL) {
		printRow(table->header, (uint32_t *)&sz, table->nCols);
		separator((uint32_t *)&sz, table->nCols);
	}

	i = 0;
	while (i < table->nRows) {
		printRow((char *(*)[])&(*data)[i], (uint32_t *)&sz, table->nCols);

		if (table->separate && i < table->nRows - 1) {
			separator((uint32_t *)&sz, table->nCols);
		}

		i = i + 1;
	}

	// bottom border
	separator((uint32_t *)&sz, table->nCols);
}


static void printRow(char *(*raw_row)[], uint32_t *sz, uint32_t nCols) {
	char *(*const row)[nCols] = (char(**)[])(char *(*)[nCols])raw_row;
	uint32_t j = 0;
	while (j < nCols) {
		printf("|");
		char *const s = (*row)[j];
		uint32_t len = (uint32_t)strlen(s);
		if (s[0] != '\x0') {
			len = len + 1;
			printf(" %s", s);
		}

		uint32_t k = 0;
		while (k < (sz[j] - len)) {
			printf(" ");
			k = k + 1;
		}
		j = j + 1;
	}
	printf("|\n");
}


// печатает строку +---+---+ отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
static void separator(uint32_t *sz, uint32_t n) {
	uint32_t i = 0;
	while (i < n) {
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


