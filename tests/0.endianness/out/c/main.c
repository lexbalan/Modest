
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	uint16_t check = 0x1;
	const bool is_le = *((uint8_t *)&check) == 0x1;

	char *kind;
	if (is_le) {
		kind = "little";
	} else {
		kind = "big";
	}

	printf("%s-endian\n", kind);

	return 0;
}


