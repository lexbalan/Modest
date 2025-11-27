
#include "memory.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

  //

#define SYSTEM_WIDTH  64


//$if (systemWidth == 64)
typedef uint64_t Word;
typedef uint64_t Nat;
//$elseif (systemWidth == 32)
//type Word Word32
//type Nat Nat32
//$endif

#define MEMORY_ALIGNMENT  (SYSTEM_WIDTH / 8)

void memory_zero(void *mem, uint64_t len) {
	const Nat z = (Nat)mem % MEMORY_ALIGNMENT;

	uint8_t *const memptr = (uint8_t *)mem;

	uint8_t *const dst_byte0 = memptr;

	// align the pointer
	uint64_t i = 0;
	while (i < z) {
		dst_byte0[i] = 0x0;
		i = i + 1;
	}

	// word operation

	const uint64_t len_words = (len - z) / sizeof(Word);
	Word *const dst_word = (Word *)&memptr[i];

	i = 0;
	while (i < len_words) {
		dst_word[i] = 0x0;
		i = i + 1;
	}

	// byte operation

	const uint64_t len_bytes = (len - z) % sizeof(Word);
	uint8_t *const dst_byte1 = (uint8_t *)&dst_word[i];

	i = 0;
	while (i < len_bytes) {
		dst_byte1[i] = 0x0;
		i = i + 1;
	}
}


void memory_copy(void *dst, void *src, uint64_t len) {
	const uint64_t len_words = len / sizeof(Word);
	Word *const src_w = (Word *)src;
	Word *const dst_w = (Word *)dst;

	uint64_t i = 0;
	while (i < len_words) {
		dst_w[i] = src_w[i];
		i = i + 1;
	}

	const uint64_t len_bytes = len % sizeof(Word);
	uint8_t *const src_b = (uint8_t *)&src_w[i];
	uint8_t *const dst_b = (uint8_t *)&dst_w[i];

	i = 0;
	while (i < len_bytes) {
		dst_b[i] = src_b[i];
		i = i + 1;
	}
}


bool memory_eq(void *mem0, void *mem1, uint64_t len) {
	const uint64_t len_words = len / sizeof(Word);
	Word *const mem0_w = (Word *)mem0;
	Word *const mem1_w = (Word *)mem1;

	uint64_t i = 0;
	while (i < len_words) {
		if (mem0_w[i] != mem1_w[i]) {
			return false;
		}
		i = i + 1;
	}

	const uint64_t len_bytes = len % sizeof(Word);
	uint8_t *const mem0_b = (uint8_t *)&mem0_w[i];
	uint8_t *const mem1_b = (uint8_t *)&mem1_w[i];

	i = 0;
	while (i < len_bytes) {
		if (mem0_b[i] != mem1_b[i]) {
			return false;
		}
		i = i + 1;
	}

	return true;
}


