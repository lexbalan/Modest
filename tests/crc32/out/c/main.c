
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

static uint8_t data[9] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

int main(void) {
	printf("CRC32 test\n");

	const uint32_t crc = crc32_run(data, LENGTHOF(data));

	printf("crc32.doHash(\"%s\") = %08X\n", DATASTRING, crc);

	if (crc == EXPECTED_HASH) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}


