
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
	const memory_Nat memory_z = (memory_Nat)mem % MEMORY_MEMORY_ALIGNMENT;
	uint8_t (*const memory_memptr)[] = (uint8_t (*)[])mem;
	uint8_t (*const memory_dst_byte0)[] = memory_memptr;
	uint64_t i = 0ULL;
	while (i < memory_z) {
		(*memory_dst_byte0)[i] = 0x0;
		i = i + 1ULL;
	}
	const uint64_t memory_len_words = (len - memory_z) / sizeof(memory_Word);
	memory_Word (*const memory_dst_word)[] = (memory_Word (*)[])&(*memory_memptr)[i];
	i = 0ULL;
	while (i < memory_len_words) {
		(*memory_dst_word)[i] = 0x0ULL;
		i = i + 1ULL;
	}
	const uint64_t memory_len_bytes = (len - memory_z) % sizeof(memory_Word);
	uint8_t (*const memory_dst_byte1)[] = (uint8_t (*)[])&(*memory_dst_word)[i];
	i = 0ULL;
	while (i < memory_len_bytes) {
		(*memory_dst_byte1)[i] = 0x0;
		i = i + 1ULL;
	}
}

void memory_copy(void *dst, void *src, uint64_t len) {
	const uint64_t memory_len_words = len / sizeof(memory_Word);
	memory_Word (*const memory_src_w)[] = (memory_Word (*)[])src;
	memory_Word (*const memory_dst_w)[] = (memory_Word (*)[])dst;
	uint64_t i = 0ULL;
	while (i < memory_len_words) {
		(*memory_dst_w)[i] = (*memory_src_w)[i];
		i = i + 1ULL;
	}
	const uint64_t memory_len_bytes = len % sizeof(memory_Word);
	uint8_t (*const memory_src_b)[] = (uint8_t (*)[])&(*memory_src_w)[i];
	uint8_t (*const memory_dst_b)[] = (uint8_t (*)[])&(*memory_dst_w)[i];
	i = 0ULL;
	while (i < memory_len_bytes) {
		(*memory_dst_b)[i] = (*memory_src_b)[i];
		i = i + 1ULL;
	}
}

bool memory_eq(void *mem0, void *mem1, uint64_t len) {
	const uint64_t memory_len_words = len / sizeof(memory_Word);
	memory_Word (*const memory_mem0_w)[] = (memory_Word (*)[])mem0;
	memory_Word (*const memory_mem1_w)[] = (memory_Word (*)[])mem1;
	uint64_t i = 0ULL;
	while (i < memory_len_words) {
		if ((*memory_mem0_w)[i] != (*memory_mem1_w)[i]) {
			return false;
		}
		i = i + 1ULL;
	}
	const uint64_t memory_len_bytes = len % sizeof(memory_Word);
	uint8_t (*const memory_mem0_b)[] = (uint8_t (*)[])&(*memory_mem0_w)[i];
	uint8_t (*const memory_mem1_b)[] = (uint8_t (*)[])&(*memory_mem1_w)[i];
	i = 0ULL;
	while (i < memory_len_bytes) {
		if ((*memory_mem0_b)[i] != (*memory_mem1_b)[i]) {
			return false;
		}
		i = i + 1ULL;
	}
	return true;
}

