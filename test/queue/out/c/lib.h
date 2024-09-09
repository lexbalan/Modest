
#ifndef LIB_H
#define LIB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"

typedef struct lib_Point lib_Point; //


typedef int32_t lib_Int;

struct lib_Point {
	lib_Int x;
	lib_Int y;
};
lib_Int lib_mid(lib_Int a, lib_Int b);
void lib_printPoint(lib_Point p);

#endif /* LIB_H */
