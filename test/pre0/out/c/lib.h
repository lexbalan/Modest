
#ifndef LIB_H
#define LIB_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"

typedef struct Point Point;


typedef int32_t Int;

struct Point {
	Int x;
	Int y;
};
Int lib_mid(Int a, Int b);
void lib_printPoint(Point p);

#endif /* LIB_H */
