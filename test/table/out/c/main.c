
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>
#include <stdlib.h>
#include <string.h>



static char *main_table_header0[3] = (char *[3]){
	"#", "Header0", "Header1"
};

static char *main_table_data0[3][3] = (char *[3][3]){
	"0", "Alef", "Betha",
	"1", "Clock", "Depth",
	"2", "Earth", "Fight"
};


static char *main_table_header1[4] = (char *[4]){
	"#", "Header0", "Header1", "Header2"
};

static char *main_table_data1[4][4] = (char *[4][4]){
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};


static table_Table main_table00 = {
	.header = NULL,
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.separate = false
};

static table_Table main_table01 = {
	.header = &main_table_header0,
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.separate = false
};

static table_Table main_table02 = {
	.header = NULL,
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.separate = true
};

static table_Table main_table03 = {
	.header = &main_table_header0,
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.separate = true
};



int32_t main()
{
	//printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	//printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))

	table_print((table_Table *)&main_table00);
	printf("\n");
	table_print((table_Table *)&main_table01);
	printf("\n");
	table_print((table_Table *)&main_table02);
	printf("\n");
	table_print((table_Table *)&main_table03);
	printf("\n");

	return 0;
}

