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

#ifndef CRC32_H
#define CRC32_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

uint32_t crc32_run(uint8_t *buf, uint32_t len);

#endif /* CRC32_H */
