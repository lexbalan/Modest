// ./out/c/sha256.h

#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


#define sha256HashSize  32

void sha256_doHash(uint8_t *msg, uint32_t msg_len, uint8_t *out_hash);

#endif /* SHA256_H */
