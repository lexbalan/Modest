
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct main_Table {
	char *(*data)[];
	uint32_t rows;
	uint32_t cols;
	bool headline;
	bool separate;
};
typedef struct main_Table main_Table;


static char *main_table_data0[3][3] = (char *[3][3]){
	"#", "Header0", "Header1",
	"0", "Alef", "Betha",
	"1", "Clock", "Depth"
};

static char *main_table_data1[5][4] = (char *[5][4]){
	"#", "Header0", "Header1", "Header2",
	"0", "Alef", "Betha", "Emma",
	"1", "Clock", "Depth", "Free",
	"2", "Ink", "Julia", "Keyword",
	"3", "Ultra", "Video", "Word"
};

static main_Table main_table00 = {
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.headline = false,
	.separate = false
};

static main_Table main_table01 = {
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.headline = true,
	.separate = false
};

static main_Table main_table02 = {
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.headline = false,
	.separate = true
};

static main_Table main_table03 = {
	.data = (void *)&main_table_data0,
	.rows = LENGTHOF(main_table_data0),
	.cols = LENGTHOF(main_table_data0[0]),
	.headline = true,
	.separate = true
};

// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions

static void main_printTableSep(uint32_t *sz, uint32_t m);
static void main_tablePrint(main_Table *table)
{
	uint32_t i;
	uint32_t j;

	uint32_t rows = table->rows;
	uint32_t cols = table->cols;
	// construct pointer to closed VLA array
	char *(*table_data)[rows][cols] = (char *(*)[rows][cols])table->data;

	// array of size of columns (in characters)
	uint32_t sz[cols];
	memset(&sz, 0, sizeof sz);

	// calculate max length (in chars) of column
	i = 0;
	while (i < table->rows) {
		j = 0;
		while (j < table->cols) {
			char *str = (*table_data)[i][j];
			uint32_t len = (uint32_t)strlen(str);
			if (len > sz[j]) {
				sz[j] = len;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < table->cols) {
		// добавляем по пробелу слева и справа
		// (для красивого отступа)
		sz[i] = sz[i] + 2;
		i = i + 1;
	}

	// begin border
	main_printTableSep((uint32_t *)&sz, table->cols);

	i = 0;
	while (i < table->rows) {
		j = 0;
		while (j < table->cols) {
			printf("|");
			char *s = (*table_data)[i][j];
			uint32_t len = (uint32_t)strlen(s);
			if (s[0] != '\x0') {
				len = len + 1;
				printf(" %s", s);
			}

			uint32_t k = 0;
			while (k < sz[j] - len) {
				printf(" ");
				k = k + 1;
			}
			j = j + 1;
		}
		printf("|\n");
		i = i + 1;

		// print `+--+--+` separator line
		if (table->separate && i < table->rows || table->headline && i <= 1) {
			main_printTableSep((uint32_t *)&sz, table->cols);
		}
	}

	// end border
	main_printTableSep((uint32_t *)&sz, table->cols);
}


// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней
static void main_printTableSep(uint32_t *sz, uint32_t m)
{
	uint32_t i = 0;
	while (i < m) {
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


int32_t main()
{
	//printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	//printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))

	main_tablePrint((main_Table *)&main_table00);
	printf("\n");
	main_tablePrint((main_Table *)&main_table01);
	printf("\n");
	main_tablePrint((main_Table *)&main_table02);
	printf("\n");
	main_tablePrint((main_Table *)&main_table03);
	printf("\n");

	return 0;
}

