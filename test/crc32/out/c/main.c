// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

/* anonymous records */
#define datastring  "123456789"
#define expected_hash  0xCBF43926





static uint8_t data[9] = datastring;

int main()
{
	printf("CRC32 test\n");

	const uint32_t crc = crc32_doHash((uint8_t *)&data, LENGTHOF(data));

	printf("crc32.doHash(\"%s\") = %08X\n", (char *)datastring, crc);

	if (crc == expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

