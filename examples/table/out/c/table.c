
#include "table.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static void separator(uint32_t sz[], uint32_t n);
static void printRow(char *raw_row[], uint32_t sz[], uint32_t nCols);

void table_print(table_Table *table) {
	uint32_t i;
	uint32_t j;
	char *(*const data)[table->nRows][table->nCols] = (char *(*)[table->nRows][table->nCols])table->data;
	uint32_t sz[table->nCols];
	__builtin_bzero(&sz, sizeof(uint32_t [table->nCols]));
	if (table->header != NULL) {
		i = 0U;
		while (i < table->nCols) {
			const uint32_t len = (uint32_t)strlen((*table->header)[i]);
			if (len > sz[i]) {
				sz[i] = len;
			}
			i = i + 1U;
		}
	}
	i = 0U;
	while (i < table->nRows) {
		j = 0U;
		while (j < table->nCols) {
			const uint32_t len = (uint32_t)strlen((*data)[i][j]);
			if (len > sz[j]) {
				sz[j] = len;
			}
			j = j + 1U;
		}
		i = i + 1U;
	}
	i = 0U;
	while (i < table->nCols) {
		sz[i] = sz[i] + 2U;
		i = i + 1U;
	}
	separator((uint32_t *)&sz, table->nCols);
	if (table->header != NULL) {
		printRow((char **)table->header, (uint32_t *)&sz, table->nCols);
		separator((uint32_t *)&sz, table->nCols);
	}
	i = 0U;
	while (i < table->nRows) {
		printRow((char **)&(*data)[i], (uint32_t *)&sz, table->nCols);
		if (table->separate && i < table->nRows - 1U) {
			separator((uint32_t *)&sz, table->nCols);
		}
		i = i + 1U;
	}
	separator((uint32_t *)&sz, table->nCols);
}

static void printRow(char *raw_row[], uint32_t sz[], uint32_t nCols) {
	char *(*const row)[nCols] = (char *(*)[nCols])raw_row;
	uint32_t j = 0U;
	while (j < nCols) {
		printf("|");
		char *const s = (*row)[j];
		uint32_t len = (uint32_t)strlen(s);
		if (s[0] != '\x0') {
			len = len + 1U;
			printf(" %s", s);
		}
		uint32_t k = 0U;
		while (k < sz[j] - len) {
			printf(" ");
			k = k + 1U;
		}
		j = j + 1U;
	}
	printf("|\n");
}

static void separator(uint32_t sz[], uint32_t n) {
	uint32_t i = 0U;
	while (i < n) {
		printf("+");
		uint32_t j = 0U;
		while (j < sz[i]) {
			printf("-");
			j = j + 1U;
		}
		i = i + 1U;
	}
	printf("+\n");
}

