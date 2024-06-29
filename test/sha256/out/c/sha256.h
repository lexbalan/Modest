// ./out/c/sha256.h

#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/* forward type declaration */
/* anon recs */

#define sha256HashSize  32

void sha256_doHash(uint8_t *msg, uint32_t msgLen, uint8_t *outHash);

#endif /* SHA256_H */
