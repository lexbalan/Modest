


#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "memory.h"



#define systemWidth  64

typedef uint64_t Word;
typedef uint64_t Nat;



#define memoryAlignment  (systemWidth / 8)


void mzero(void *mem, uint64_t len)
{
	Nat z = (Nat)mem % memoryAlignment;

	uint8_t *memptr = (uint8_t *)mem;

	uint8_t *dst_byte0 = memptr;

	//{'str': ' align the pointer'}
	uint64_t i = 0;
	while (i < z) {
		dst_byte0[i] = 0;
		i = i + 1;
	}

	//{'str': ' word operation'}

	uint64_t len_words = (len - z) / sizeof(Word);
	Word *dst_word = (Word *)&memptr[i];

	i = 0;
	while (i < len_words) {
		dst_word[i] = 0;
		i = i + 1;
	}

	//{'str': ' byte operation'}

	uint64_t len_bytes = (len - z) % sizeof(Word);
	uint8_t *dst_byte1 = (uint8_t *)&dst_word[i];

	i = 0;
	while (i < len_bytes) {
		dst_byte1[i] = 0;
		i = i + 1;
	}
}


void mcopy(void *dst, void *src, uint64_t len)
{
	uint64_t len_words = len / sizeof(Word);
	Word *src_w = (Word *)src;
	Word *dst_w = (Word *)dst;

	uint64_t i = 0;
	while (i < len_words) {
		dst_w[i] = src_w[i];
		i = i + 1;
	}

	uint64_t len_bytes = len % sizeof(Word);
	uint8_t *src_b = (uint8_t *)&src_w[i];
	uint8_t *dst_b = (uint8_t *)&dst_w[i];

	i = 0;
	while (i < len_bytes) {
		dst_b[i] = src_b[i];
		i = i + 1;
	}
}


bool meq(void *mem0, void *mem1, uint64_t len)
{
	uint64_t len_words = len / sizeof(Word);
	Word *mem0_w = (Word *)mem0;
	Word *mem1_w = (Word *)mem1;

	uint64_t i = 0;
	while (i < len_words) {
		if (mem0_w[i] != mem1_w[i]) {
			return false;
		}
		i = i + 1;
	}

	uint64_t len_bytes = len % sizeof(Word);
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

