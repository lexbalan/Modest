
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./lib/lib.h"

int main(void) {
	struct lib_librarian librarian;
	struct mod1_mod mod1;
	struct mod2_mod mod2;
	printf("lib.mod1.modName = '%s'\n", MOD1_MOD_NAME);
	printf("lib.mod2.modName = '%s'\n", MOD2_MOD_NAME);
	return 0;
}

