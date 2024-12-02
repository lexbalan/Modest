
//include "libc/ctypes64"
//include "libc/stdio"

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "crc32.h"

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

uint32_t crc32_doHash(uint8_t *buf, uint32_t len)
{
	#define __tableSize  256
	uint32_t crc_table[__tableSize];
	uint32_t crc;

	//
	// create table before
	//

	uint32_t i = 0;
	while (i < __tableSize) {
		crc = (uint32_t)i;
		uint32_t j = 0;
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
		const uint32_t y = (crc ^ (uint32_t)buf[i]) & 0xFF;
		const uint8_t yy = (uint8_t)y;
		crc = crc_table[yy] ^ crc >> 8;
		i = i + 1;
	}

	return crc ^ 0xFFFFFFFF;

#undef __tableSize
}

