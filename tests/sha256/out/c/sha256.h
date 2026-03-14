
#if !defined(SHA256_H)
#define SHA256_H
#include <string.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#define SHA256_HASH_SIZE 32
typedef uint8_t sha256_Hash[SHA256_HASH_SIZE];
//@inline
//func rotleft (a: Word32, b: Nat32) -> Word32 {
//	return (a << b) or (a >> (32 - b))
//}
void sha256_hash(uint8_t (*msg)[], uint32_t msgLen, sha256_Hash *outHash);
#endif
