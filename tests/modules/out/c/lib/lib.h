
#if !defined(LIB_H)
#define LIB_H
#include "mod1.h"
#include "mod2.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#define LIB_LENN 10
struct lib_librarian {
	char *name;
	char name2[LIB_LENN];
};
void lib_printf(char *s, ...);
#endif

