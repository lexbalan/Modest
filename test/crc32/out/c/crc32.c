


#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "crc32.h"


uint32_t crc32_run(uint8_t *buf, uint32_t len)
{
	#define __tableSize  256
	uint32_t crc_table[__tableSize];
	uint32_t crc;

	//{'str': ''}
	//{'str': ' create table before'}
	//{'str': ''}

	uint32_t i = 0;
	while (i < __tableSize) {
		crc = (uint32_t)i;
		uint32_t j = 0;
		while (j < 8) {
			if ((crc & 1) != 0) {
				crc = crc >> 1 ^ 0xEDB88320U;
			} else {
				crc = crc >> 1;
			}

			j = j + 1;
		}
		crc_table[i] = crc;
		i = i + 1;
	}

	//{'str': ''}
	//{'str': ' calculate CRC32'}
	//{'str': ''}

	crc = 0xFFFFFFFFU;

	i = 0;
	while (i < len) {
		uint32_t y = (crc ^ (uint32_t)buf[i]) & 0xFF;
		uint8_t yy = (uint8_t)y;
		crc = crc_table[yy] ^ crc >> 8;
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFFU;

#undef __tableSize
}

