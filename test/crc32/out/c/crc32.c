
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "crc32.h"




uint32_t crc32_doHash(uint8_t *buf, uint32_t len)
{
	#define __tableSize  256
	uint32_t crc_table[__tableSize];
	uint32_t crc;

	//
	// create table before
	//

	uint32_t i;
	i = 0;
	while (i < __tableSize) {
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

	//
	// calculate CRC32
	//

	crc = 0xFFFFFFFF;

	i = 0;
	while (i < len) {
		const uint32_t yy = (crc ^ (uint32_t)buf[i]) & 0xFF;
		crc = crc_table[yy] ^ crc >> 8;
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFF;

#undef __tableSize
}

