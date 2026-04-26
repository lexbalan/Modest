
#include "memory.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
//
#define MEMORY_SYSTEM_WIDTH 64
typedef uint64_t memory_Word;
typedef uint64_t memory_Nat;
//$elseif (systemWidth == 32)
//type Word Word32
//type Nat Nat32
//$endif
#define MEMORY_MEMORY_ALIGNMENT (MEMORY_SYSTEM_WIDTH / 8)

void memory_zero(void *mem, uint64_t len) {
	const memory_Nat z = (memory_Nat)mem % MEMORY_MEMORY_ALIGNMENT;
	uint8_t (*const memptr)[] = (uint8_t (*)[])mem;
	uint8_t (*const dst_byte0)[] = memptr;
	uint64_t i = 0ULL;
	while (i < z) {
		(*dst_byte0)[i] = 0x0;
		i = i + 1ULL;
	}
	const uint64_t len_words = (len - z) / sizeof(memory_Word);
	memory_Word (*const dst_word)[] = (memory_Word (*)[])&(*memptr)[i];
	i = 0ULL;
	while (i < len_words) {
		(*dst_word)[i] = 0x0ULL;
		i = i + 1ULL;
	}
	const uint64_t len_bytes = (len - z) % sizeof(memory_Word);
	uint8_t (*const dst_byte1)[] = (uint8_t (*)[])&(*dst_word)[i];
	i = 0ULL;
	while (i < len_bytes) {
		(*dst_byte1)[i] = 0x0;
		i = i + 1ULL;
	}
}

void memory_copy(void *dst, void *src, uint64_t len) {
	const uint64_t len_words = len / sizeof(memory_Word);
	memory_Word (*const src_w)[] = (memory_Word (*)[])src;
	memory_Word (*const dst_w)[] = (memory_Word (*)[])dst;
	uint64_t i = 0ULL;
	while (i < len_words) {
		(*dst_w)[i] = (*src_w)[i];
		i = i + 1ULL;
	}
	const uint64_t len_bytes = len % sizeof(memory_Word);
	uint8_t (*const src_b)[] = (uint8_t (*)[])&(*src_w)[i];
	uint8_t (*const dst_b)[] = (uint8_t (*)[])&(*dst_w)[i];
	i = 0ULL;
	while (i < len_bytes) {
		(*dst_b)[i] = (*src_b)[i];
		i = i + 1ULL;
	}
}

bool memory_eq(void *mem0, void *mem1, uint64_t len) {
	const uint64_t len_words = len / sizeof(memory_Word);
	memory_Word (*const mem0_w)[] = (memory_Word (*)[])mem0;
	memory_Word (*const mem1_w)[] = (memory_Word (*)[])mem1;
	uint64_t i = 0ULL;
	while (i < len_words) {
		if ((*mem0_w)[i] != (*mem1_w)[i]) {
			return false;
		}
		i = i + 1ULL;
	}
	const uint64_t len_bytes = len % sizeof(memory_Word);
	uint8_t (*const mem0_b)[] = (uint8_t (*)[])&(*mem0_w)[i];
	uint8_t (*const mem1_b)[] = (uint8_t (*)[])&(*mem1_w)[i];
	i = 0ULL;
	while (i < len_bytes) {
		if ((*mem0_b)[i] != (*mem1_b)[i]) {
			return false;
		}
		i = i + 1ULL;
	}
	return true;
}

