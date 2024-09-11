// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define datastring  "123456789"
#define expected_hash  0xCBF43926
uint32_t do_crc32(uint8_t *buf, uint32_t len);
int main();



static uint8_t data[9] = (uint8_t *)datastring;

uint32_t do_crc32(uint8_t *buf, uint32_t len)
{
	uint32_t crc_table[256];
	uint32_t crc;

	uint32_t i;
	i = 0;
	while (i < (sizeof(crc_table) / sizeof(crc_table[0]))) {
		crc = i;
		uint32_t j;
		j = 0;
		while (j < 8) {
			if ((crc & 1) != 0) {
				crc = crc >> 1 ^ 0xEDB88320;
			} else {
				crc = crc >> 1;
			}

			j = j + 1;
		}
		crc_table[i] = crc;
		i = i + 1;
	}

	crc = 0xFFFFFFFF;

	i = 0;
	while (i < len) {
		const uint32_t yy = (crc ^ (uint32_t)buf[i]) & 0xFF;
		crc = crc_table[yy] ^ crc >> 8;
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFF;
}

int main()
{
	printf("CRC32 test\n");

	const uint32_t crc = do_crc32((uint8_t *)&data, (sizeof(data) / sizeof(data[0])));

	printf("CRC32(%s) = %08X\n", (char *)datastring, crc);

	if (crc == expected_hash) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

