
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */


static char *table_header0[3] = {
	"#", "Header0", "Header1"
};

static char *table_data0[3][3] = {
	"0", "Alef", "Betha",
	"1", "Clock", "Depth",
	"2", "Earth", "Fight"
};

static char *table_header1[4] = {
	"#", "Header0", "Header1", "Header2"
};

static char *table_data1[4][4] = {
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};

static table_Table table00 = {
	.header = NULL,
	.data = (void *)&table_data0,
	.nRows = __lengthof(table_data0),
	.nCols = __lengthof(table_data0[0]),
	.separate = false
};

static table_Table table01 = {
	.header = &table_header0,
	.data = (void *)&table_data0,
	.nRows = __lengthof(table_data0),
	.nCols = __lengthof(table_data0[0]),
	.separate = false
};

static table_Table table02 = {
	.header = NULL,
	.data = (void *)&table_data0,
	.nRows = __lengthof(table_data0),
	.nCols = __lengthof(table_data0[0]),
	.separate = true
};

static table_Table table03 = {
	.header = &table_header0,
	.data = (void *)&table_data0,
	.nRows = __lengthof(table_data0),
	.nCols = __lengthof(table_data0[0]),
	.separate = true
};

static table_Table table10 = {
	.header = &table_header1,
	.data = (void *)&table_data1,
	.nRows = __lengthof(table_data1),
	.nCols = __lengthof(table_data1[0]),
	.separate = true
};

int32_t main()
{
	table_Table *const tab = (table_Table *)calloc(1, sizeof(table_Table));

	if (tab == NULL) {
		printf("cannot create object\n");
	}

	*tab = table00;

	table_print((table_Table *)&table00);
	printf("\n");

	table_print((table_Table *)&table01);
	printf("\n");

	table_print((table_Table *)&table02);
	printf("\n");

	table_print((table_Table *)&table03);
	printf("\n");

	table_print((table_Table *)&table10);
	printf("\n");

	return 0;
}

