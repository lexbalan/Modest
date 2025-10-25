
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


static char *table_header0[3] = {
	"#", "Header0", "Header1"
};

static char *tableData0[3][3] = {
	"0", "Alef", "Betha",
	"1", "Clock", "Depth",
	"2", "Earth", "Fight"
};

static char *table_header1[4] = {
	"#", "Header0", "Header1", "Header2"
};

static char *tableData1[4][4] = {
	"0", "Alef", "Betha", "Clock",
	"1", "Depth", "Emma", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};

static table_Table table00 = {
	.header = NULL,
	.data = (void *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = false
};

static table_Table table01 = {
	.header = &table_header0,
	.data = (void *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = false
};

static table_Table table02 = {
	.header = NULL,
	.data = (void *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = true
};

static table_Table table03 = {
	.header = &table_header0,
	.data = (void *)&tableData0,
	.nRows = LENGTHOF(tableData0),
	.nCols = LENGTHOF(tableData0[0]),
	.separate = true
};

static table_Table table10 = {
	.header = &table_header1,
	.data = (void *)&tableData1,
	.nRows = LENGTHOF(tableData1),
	.nCols = LENGTHOF(tableData1[0]),
	.separate = true
};

int32_t main() {
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


