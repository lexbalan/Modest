
#ifndef CRC32_H
#define CRC32_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

uint32_t crc32_run(uint8_t *buf, uint32_t len);

#endif /* CRC32_H */
