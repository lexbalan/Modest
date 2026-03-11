
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "table.h"

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */

static char *table_header0[3] = /*CA2*/{"#", "Header0", "Header1"};
static char *tableData0[3][3] = /*CA2*/{/*CA2*/{"0", "Alef", "Betha"}, /*CA2*/{"1", "Clock", "Depth"}, /*CA2*/{"2", "Earth", "Fight"}};
static char *table_header1[4] = /*CA2*/{"#", "Header0", "Header1", "Header2"};
static char *tableData1[4][4] = /*CA2*/{/*CA2*/{"0", "Alef", "Betha", "Clock"}, /*CA2*/{"1", "Depth", "Emma", "Free"}, /*CA2*/{"2", "Ink", "Julia", "Keyword"}, /*CA2*/{"3", "Ultra", "Video", "Word"}};
static table_Table table00 = /*CR4*/(table_Table){
	.header = NULL,
	.data = (table_Row *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = false
};
static table_Table table01 = /*CR4*/(table_Table){
	.header = &table_header0,
	.data = (table_Row *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = false
};
static table_Table table02 = /*CR4*/(table_Table){
	.header = NULL,
	.data = (table_Row *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = true
};
static table_Table table03 = /*CR4*/(table_Table){
	.header = &table_header0,
	.data = (table_Row *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = true
};
static table_Table table10 = /*CR4*/(table_Table){
	.header = &table_header1,
	.data = (table_Row *)&tableData1,
	.nRows = LENGTHOF(tableData1),
	.nCols = LENGTHOF(tableData1[0]),
	.separate = true
};

int32_t main(void) {
	table_print(&table00);
	printf("\n");
	table_print(&table01);
	printf("\n");
	table_print(&table02);
	printf("\n");
	table_print(&table03);
	printf("\n");
	table_print(&table10);
	printf("\n");
	return 0;
}

