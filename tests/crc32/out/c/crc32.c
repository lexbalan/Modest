
#include "crc32.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define TABLE_SIZE  256

static uint32_t table[TABLE_SIZE];


// initialize table
void crc32_init(void) {
	uint32_t i = 0;
	while (i < TABLE_SIZE) {
		uint32_t crc = i;
		uint32_t j = 0;
		while (j < 8) {
			if ((crc & 0x1) != 0x0) {
				crc = (crc >> 1) ^ 0xEDB88320L;
			} else {
				crc = crc >> 1;
			}

			j = j + 1;
		}
		table[i] = crc;
		i = i + 1;
	}
}



// calculate CRC32
uint32_t crc32_run(uint8_t (*buf)[], uint32_t len) {
	uint32_t crc = 0xFFFFFFFFL;
	uint32_t i = 0;
	while (i < len) {
		const uint32_t x = (uint32_t)(*buf)[i];
		const uint32_t y = (crc ^ x) & 0xFF;
		const uint8_t yy = (uint8_t)y;
		crc = table[yy] ^ (crc >> 8);
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFFL;
}


