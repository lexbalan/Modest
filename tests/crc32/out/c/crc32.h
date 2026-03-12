
#if !defined(CRC32_H)
#define CRC32_H
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
void crc32_init(void);
uint32_t crc32_run(uint8_t (*buf)[], uint32_t len);
#endif
