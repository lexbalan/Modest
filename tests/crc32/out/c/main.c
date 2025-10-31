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


#define DATASTRING  "123456789"
#define EXPECTED_HASH  0xCBF43926UL

static uint8_t data[9] = DATASTRING;

int main() {
	printf("CRC32 test\n");

	const uint32_t crc = crc32_run((uint8_t *)&data, LENGTHOF(data));

	printf("crc32.doHash(\"%s\") = %08X\n", DATASTRING, crc);

	if (crc == EXPECTED_HASH) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}


