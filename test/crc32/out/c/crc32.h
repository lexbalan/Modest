
#ifndef CRC32_H
#define CRC32_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


uint32_t crc32_doHash(uint8_t *buf, uint32_t len);

#endif /* CRC32_H */
