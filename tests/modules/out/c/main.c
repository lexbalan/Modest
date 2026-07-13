
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./lib/lib.h"
#include "./lib/mod1.h"
#include "./lib/mod2.h"
//pragma c_include "./lib/lib.h"
//pragma c_include "./lib/mod1.h"
//pragma c_include "./lib/mod2.h"

int main(void) {
	lib_Librarian librarian;
	struct mod1_mod m1;
	struct mod2_mod m2;
	printf("mod1.modName = '%s'\n", "mod1");
	printf("mod2.modName = '%s'\n", "mod2");
	lib_printf("hi!\n");
	return 0;
}

