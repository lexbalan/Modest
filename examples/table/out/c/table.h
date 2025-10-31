/*
 * table.m
 */

#ifndef TABLE_H
#define TABLE_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct table_Row {
};
typedef struct table_Row table_Row;

struct table_Table {
	char *(*header)[];
	char *(*data)[];
	uint32_t nRows;
	uint32_t nCols;
	bool separate;
};
typedef struct table_Table table_Table;
void table_print(table_Table *table);

#endif /* TABLE_H */
