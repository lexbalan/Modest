// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define main_datastring  "123456789"
#define main_expected_hash  0xCBF43926
int main();




static uint8_t data[9] = main_datastring;

int main()
{
	printf("CRC32 test\n");

	const uint32_t crc = crc32_doHash((uint8_t *)&data, sizeof data);

	printf("crc32.doHash(\"%s\") = %08X\n", (char *)main_datastring, crc);

	if (crc == main_expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

