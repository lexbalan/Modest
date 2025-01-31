
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))
#include <stdio.h>

#include "./crc32.h"




#define main_datastring  "123456789"
#define main_expected_hash  0xCBF43926


static uint8_t main_data[9] = main_datastring;


int main()
{
	printf("CRC32 test\n");

	uint32_t crc = crc32_run((uint8_t *)&main_data, LENGTHOF(main_data));

	printf("crc32.doHash(\"%s\") = %08X\n", (char *)main_datastring, crc);

	if (crc == main_expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

