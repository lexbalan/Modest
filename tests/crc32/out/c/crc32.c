
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "crc32.h"


uint32_t crc32_run(uint8_t *buf, uint32_t len)
{
	#define __tableSize  256
	uint32_t crc_table[__tableSize];
	memset(&crc_table, 0, sizeof crc_table);
	uint32_t crc;

	//
	// create table before
	//

	uint32_t i = 0;
	while (i < __tableSize) {
		crc = i;
		uint32_t j = 0;
		while (j < 8) {
			if ((crc & 1) != 0) {
				crc = (crc >> 1) ^ 0xEDB88320U;
			} else {
				crc = crc >> 1;
			}

			j = j + 1;
		}
		crc_table[i] = crc;
		i = i + 1;
	}

	//
	// calculate CRC32
	//

	crc = 0xFFFFFFFFU;

	i = 0;
	while (i < len) {
		// 1
		const uint32_t x = buf[i];
		const uint32_t y = (crc ^ x) & 0xFF;
		// 2
		const uint8_t yy = y;
		crc = crc_table[yy] ^ (crc >> 8);
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFFU;

#undef __tableSize
}

