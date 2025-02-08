
#ifndef TABLE_H
#define TABLE_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>






struct table_Table {
	char *(*header)[];
	char *(*data)[];
	uint32_t rows;
	uint32_t cols;
	bool separate;
};
typedef struct table_Table table_Table;


// we cannot receive VLA by value,
// but we can receive pointer to open array
// and after construct pointer to closed array with required dimensions
void table_print(table_Table *table);





// печатает строку отделяющую записи таблицы
// получает указатель на массив с размерами колонок
// и количество элементов в ней


#endif /* TABLE_H */
