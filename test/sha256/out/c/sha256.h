
#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>
#include <string.h>
#include <stdbool.h>



#define sha256HashSize  32

void sha256_doHash(uint8_t *msg, uint32_t len, uint8_t *hash);

#endif  /* SHA256_H */
