/*
  Name  : CRC-32
  Poly  : 0x04C11DB7    xxor32 + xxor26 + xxor23 + xxor22 + xxor16 + xxor12 + xxor11
                       + xxor10 + xxor8 + xxor7 + xxor5 + xxor4 + xxor2 + x + 1
  Init  : 0xFFFFFFFF
  Revert: true
  XorOut: 0xFFFFFFFF
  Check : 0xCBF43926 ("123456789")
  MaxLen: 268 435 455 байт (2 147 483 647 бит) - обнаружение
   одинарных, двойных, пакетных и всех нечетных ошибок
*/

#include "crc32.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



uint32_t crc32_run(uint8_t *buf, uint32_t len) {
	#define tableSize  256
	uint32_t crc_table[tableSize];
	uint32_t crc;

	//
	// create table before
	//

	uint32_t i = 0;
	while (i < tableSize) {
		crc = i;
		uint32_t j = 0;
		while (j < 8) {
			if ((crc & 0x1) != 0x0) {
				crc = (crc >> 1) ^ 0xEDB88320UL;
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

	crc = 0xFFFFFFFFUL;

	i = 0;
	while (i < len) {
		// 1
		const uint32_t x = (uint32_t)buf[i];
		const uint32_t y = (crc ^ x) & 0xFF;
		// 2
		const uint8_t yy = (uint8_t)y;
		crc = crc_table[yy] ^ (crc >> 8);
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFFUL;

#undef tableSize
}


