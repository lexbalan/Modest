
#ifndef SHA256_H
#define SHA256_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <string.h>


#define SHA256_HASH_SIZE  32

typedef uint8_t sha256_Hash[SHA256_HASH_SIZE];
void sha256_hash(uint8_t(*msg)[], uint32_t msgLen, sha256_Hash *outHash);

#endif /* SHA256_H */
