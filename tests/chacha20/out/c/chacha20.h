
#ifndef CHACHA20_H
#define CHACHA20_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


typedef uint32_t chacha20_Key[8];
typedef uint32_t chacha20_State[16];
typedef uint32_t chacha20_Block[16];
void chacha20_chacha20Block(chacha20_State *_state, chacha20_Block *_sret_);
void chacha20_makeState(chacha20_Key *key, uint32_t counter, uint32_t (*nonce)[3], chacha20_State *_sret_);

#endif /* CHACHA20_H */
