
#include "crc32.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define CRC32_TABLE_SIZE 256
static uint32_t crc32_table[CRC32_TABLE_SIZE];

void crc32_init(void) {
	uint32_t i = 0U;
	while (i < CRC32_TABLE_SIZE) {
		uint32_t crc = i;
		uint32_t j = 0U;
		while (j < 8U) {
			if ((crc & 0x1U) != 0x0U) {
				crc = crc >> 1 ^ 0xEDB88320U;
			} else {
				crc = crc >> 1;
			}
			j = j + 1U;
		}
		crc32_table[i] = crc;
		i = i + 1U;
	}
}

uint32_t crc32_run(uint8_t buf[], uint32_t len) {
	uint32_t crc = 0xFFFFFFFFU;
	uint32_t i = 0U;
	while (i < len) {
		const uint32_t x = (uint32_t)buf[i];
		const uint32_t y = crc ^ (x & 0xFFU);
		const uint8_t yy = (uint8_t)y;
		crc = crc32_table[yy] ^ crc >> 8;
		i = i + 1U;
	}
	return crc ^ 0xFFFFFFFFU;
}

