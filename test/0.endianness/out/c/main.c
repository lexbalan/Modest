// examples/0.endianness/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
	uint16_t check;
	check = 0x0001;
	const bool is_le = *(uint8_t *)&check == 1;

	char *kind;
	if (is_le) {
		kind = "little";
	} else {
		kind = "big";
	}

	printf("%s-endian\n", kind);

	return 0;
}

