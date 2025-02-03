//

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "memory.h"
//

#define memory_systemWidth  64


//$if (systemWidth == 64)
typedef uint64_t memory_Word;
typedef uint64_t memory_Nat;
//$elseif (systemWidth == 32)
//type Word Word32
//type Nat Nat32
//$endif


#define memory_memoryAlignment  (memory_systemWidth / 8)


void memory_zero(void *mem, uint64_t len)
{
	memory_Nat z = (memory_Nat)mem % memory_memoryAlignment;

	uint8_t *memptr = (uint8_t *)mem;

	uint8_t *dst_byte0 = memptr;

	// align the pointer
	uint64_t i = 0;
	while (i < z) {
		dst_byte0[i] = 0;
		i = i + 1;
	}

	// word operation

	uint64_t len_words = (len - z) / sizeof(memory_Word);
	memory_Word *dst_word = (memory_Word *)&memptr[i];

	i = 0;
	while (i < len_words) {
		dst_word[i] = 0;
		i = i + 1;
	}

	// byte operation

	uint64_t len_bytes = (len - z) % sizeof(memory_Word);
	uint8_t *dst_byte1 = (uint8_t *)&dst_word[i];

	i = 0;
	while (i < len_bytes) {
		dst_byte1[i] = 0;
		i = i + 1;
	}
}


void memory_copy(void *dst, void *src, uint64_t len)
{
	uint64_t len_words = len / sizeof(memory_Word);
	memory_Word *src_w = (memory_Word *)src;
	memory_Word *dst_w = (memory_Word *)dst;

	uint64_t i = 0;
	while (i < len_words) {
		dst_w[i] = src_w[i];
		i = i + 1;
	}

	uint64_t len_bytes = len % sizeof(memory_Word);
	uint8_t *src_b = (uint8_t *)&src_w[i];
	uint8_t *dst_b = (uint8_t *)&dst_w[i];

	i = 0;
	while (i < len_bytes) {
		dst_b[i] = src_b[i];
		i = i + 1;
	}
}


bool memory_eq(void *mem0, void *mem1, uint64_t len)
{
	uint64_t len_words = len / sizeof(memory_Word);
	memory_Word *mem0_w = (memory_Word *)mem0;
	memory_Word *mem1_w = (memory_Word *)mem1;

	uint64_t i = 0;
	while (i < len_words) {
		if (mem0_w[i] != mem1_w[i]) {
			return false;
		}
		i = i + 1;
	}

	uint64_t len_bytes = len % sizeof(memory_Word);
	uint8_t *mem0_b = (uint8_t *)&mem0_w[i];
	uint8_t *mem1_b = (uint8_t *)&mem1_w[i];

	i = 0;
	while (i < len_bytes) {
		if (mem0_b[i] != mem1_b[i]) {
			return false;
		}
		i = i + 1;
	}

	return true;
}

