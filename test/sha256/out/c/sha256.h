
#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <string.h>



typedef struct sha256_Context sha256_Context; //
#define hashSize  32

typedef uint8_t * sha256_Hash;
void sha256_hash(uint8_t *msg, uint32_t msgLen, uint8_t *outHash);

#endif /* SHA256_H */
