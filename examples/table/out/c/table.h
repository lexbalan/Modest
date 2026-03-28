
#if !defined(TABLE_H)
#define TABLE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
typedef char *table_Row[];
typedef struct table_table table_Table;
struct table_table {
	char *(*header)[];
	void *data;
	uint32_t nRows;
	uint32_t nCols;
	bool separate;
};
void table_print(table_Table *table);
#endif

