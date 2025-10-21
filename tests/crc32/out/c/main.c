// tests/crc32/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./crc32.h"

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define datastring  "123456789"
#define expected_hash  0xCBF43926UL

static uint8_t data[9] = datastring;

int main() {
	printf("CRC32 test\n");

	const uint32_t crc = crc32_run((uint8_t *)&data, LENGTHOF(data));

	printf("crc32.doHash(\"%s\") = %08X\n", datastring, crc);

	if (crc == expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}


#undef LENGTHOF

