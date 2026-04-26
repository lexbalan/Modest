
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "table.h"
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
static char *main_table_header0[3] = {
	"#", "Header0", "Header1"
};
static char *main_tableData0[3][3] = {
	{"0", "Alef", "Betha"},
	{"1", "Clock", "Depth"},
	{"2", "Earth", "Fight"}
};
static char *main_table_header1[4] = {
	"#", "Header0", "Header1", "Header2"
};
static char *main_tableData1[4][4] = {
	{"0", "Alef", "Betha", "Clock"},
	{"1", "Depth", "Emma", "Free"},
	{"2", "Ink", "Julia", "Keyword"},
	{"3", "Ultra", "Video", "Word"}
};
static table_Table main_table00 = (table_Table){
	.header = NULL,
	.data = &main_tableData0,
	.nRows = LENGTHOF(main_tableData0),
	.nCols = LENGTHOF(main_tableData0[0]),
	.separate = false
};
static table_Table main_table01 = (table_Table){
	.header = &main_table_header0,
	.data = &main_tableData0,
	.nRows = LENGTHOF(main_tableData0),
	.nCols = LENGTHOF(main_tableData0[0]),
	.separate = false
};
static table_Table main_table02 = (table_Table){
	.header = NULL,
	.data = &main_tableData0,
	.nRows = LENGTHOF(main_tableData0),
	.nCols = LENGTHOF(main_tableData0[0]),
	.separate = true
};
static table_Table main_table03 = (table_Table){
	.header = &main_table_header0,
	.data = &main_tableData0,
	.nRows = LENGTHOF(main_tableData0),
	.nCols = LENGTHOF(main_tableData0[0]),
	.separate = true
};
static table_Table main_table10 = (table_Table){
	.header = &main_table_header1,
	.data = &main_tableData1,
	.nRows = LENGTHOF(main_tableData1),
	.nCols = LENGTHOF(main_tableData1[0]),
	.separate = true
};

int32_t main(void) {
	table_print(&main_table00);
	printf("\n");
	table_print(&main_table01);
	printf("\n");
	table_print(&main_table02);
	printf("\n");
	table_print(&main_table03);
	printf("\n");
	table_print(&main_table10);
	printf("\n");
	return 0;
}

