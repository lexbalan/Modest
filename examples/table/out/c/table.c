
#include "table.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void separator(uint32_t *sz, uint32_t n);
static void printRow(char **raw_row, uint32_t *sz, uint32_t nCols);

void table_print(table_Table *table) {
	uint32_t i;
	uint32_t j;
	char *(*const data)[table->nCols] = (char *(*)[table->nCols])table->data;
	uint32_t sz[table->nCols];
	__builtin_bzero(&sz, sizeof(uint32_t) * table->nCols);
	if (table->header != NULL) {
		i = 0;
		while (i < table->nCols) {
			const uint32_t len = (uint32_t)strlen(table->header[i]);
			if (len > sz[i]) {
				sz[i] = len;
			}
			++i;
		}
	}
	i = 0;
	while (i < table->nRows) {
		j = 0;
		while (j < table->nCols) {
			const uint32_t len = (uint32_t)strlen(data[i][j]);
			if (len > sz[j]) {
				sz[j] = len;
			}
			++j;
		}
		++i;
	}
	i = 0;
	while (i < table->nCols) {
		sz[i] = sz[i] + 2;
		++i;
	}
	separator(sz, table->nCols);
	if (table->header != NULL) {
		printRow(table->header, sz, table->nCols);
		separator(sz, table->nCols);
	}
	i = 0;
	while (i < table->nRows) {
		printRow(data[i], sz, table->nCols);
		if (table->separate && i < table->nRows - 1) {
			separator(sz, table->nCols);
		}
		++i;
	}
	separator(sz, table->nCols);
}

static void printRow(char **raw_row, uint32_t *sz, uint32_t nCols) {
	char **const row = (char **)raw_row;
	uint32_t j = 0;
	while (j < nCols) {
		printf("|");
		char *const s = row[j];
		uint32_t len = (uint32_t)strlen(s);
		if (s[0] != '\x0') {
			len = len + 1;
			printf(" %s", s);
		}
		uint32_t k = 0;
		while (k < sz[j] - len) {
			printf(" ");
			++k;
		}
		++j;
	}
	printf("|\n");
}

static void separator(uint32_t *sz, uint32_t n) {
	uint32_t i = 0;
	while (i < n) {
		printf("+");
		uint32_t j = 0;
		while (j < sz[i]) {
			printf("-");
			++j;
		}
		++i;
	}
	printf("+\n");
}

