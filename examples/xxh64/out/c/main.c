
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
// thx: https://github.com/Cyan4973/xxHash
//
// Арифметика хэша — по модулю 2^64 (обёртка), поэтому значения живут
// в Word64 (битовые операции), а сложение/умножение делаются через Nat64.
#define PRIME64_1 0x9E3779B185EBCA87ULL
#define PRIME64_2 0xC2B2AE3D27D4EB4FULL
#define PRIME64_3 0x165667B19E3779F9UL
#define PRIME64_4 0x85EBCA77C2B2AE63ULL
#define PRIME64_5 0x27D4EB2F165667C5UL
// wrapping-арифметика над Word64

__attribute__((always_inline))
static inline uint64_t add(uint64_t a, uint64_t b) {
	return a + b;
}

__attribute__((always_inline))
static inline uint64_t sub(uint64_t a, uint64_t b) {
	return a - b;
}

__attribute__((always_inline))
static inline uint64_t mul(uint64_t a, uint64_t b) {
	return a * b;
}

__attribute__((always_inline))
static inline uint64_t rotl64(uint64_t value, uint32_t amt) {
	return value << amt % 64 | value >> (64 - amt % 64);
}

static uint64_t read32(uint8_t *data, size_t offset) {
	uint64_t v = 0;
	size_t i = 0;
	while (i < 4) {
		v = v | (uint64_t)data[offset + i] << i * 8;
		++i;
	}
	return v;
}

static uint64_t read64(uint8_t *data, size_t offset) {
	uint64_t v = 0;
	size_t i = 0;
	while (i < 8) {
		v = v | (uint64_t)data[offset + i] << i * 8;
		++i;
	}
	return v;
}


static uint64_t round(uint64_t acc, uint64_t input) {
	uint64_t a = add(acc, mul(input, PRIME64_2));
	a = rotl64(a, 31);
	return mul(a, PRIME64_1);
}


static uint64_t mergeRound(uint64_t hash, uint64_t acc) {
	uint64_t h = hash ^ round(0x0, acc);
	h = mul(h, PRIME64_1);
	return add(h, PRIME64_4);
}


static uint64_t avalanche(uint64_t hash) {
	uint64_t h = hash;
	h = h ^ h >> 33;
	h = mul(h, PRIME64_2);
	h = h ^ h >> 29;
	h = mul(h, PRIME64_3);
	h = h ^ h >> 32;
	return h;
}


static uint64_t xxh64(uint8_t *input, size_t length, uint64_t seed) {
	uint64_t hash = 0;
	size_t remaining = length;
	size_t offset = 0;
	if (input == NULL) {
		return avalanche(add(seed, PRIME64_5));
	}
	if (remaining >= 32) {
		uint64_t acc1 = add(add(seed, PRIME64_1), PRIME64_2);
		uint64_t acc2 = add(seed, PRIME64_2);
		uint64_t acc3 = seed;
		uint64_t acc4 = sub(seed, PRIME64_1);
		while (remaining >= 32) {
			acc1 = round(acc1, read64(input, offset));
			offset = offset + 8;
			acc2 = round(acc2, read64(input, offset));
			offset = offset + 8;
			acc3 = round(acc3, read64(input, offset));
			offset = offset + 8;
			acc4 = round(acc4, read64(input, offset));
			offset = offset + 8;
			remaining = remaining - 32;
		}
		hash = add(add(rotl64(acc1, 1), rotl64(acc2, 7)), add(rotl64(acc3, 12), rotl64(acc4, 18)));
		hash = mergeRound(hash, acc1);
		hash = mergeRound(hash, acc2);
		hash = mergeRound(hash, acc3);
		hash = mergeRound(hash, acc4);
	} else {
		hash = add(seed, PRIME64_5);
	}
	hash = add(hash, (uint64_t)length);
	while (remaining >= 8) {
		hash = hash ^ round(0x0, read64(input, offset));
		hash = rotl64(hash, 27);
		hash = mul(hash, PRIME64_1);
		hash = add(hash, PRIME64_4);
		offset = offset + 8;
		remaining = remaining - 8;
	}
	if (remaining >= 4) {
		hash = hash ^ mul(read32(input, offset), PRIME64_1);
		hash = rotl64(hash, 23);
		hash = mul(hash, PRIME64_2);
		hash = add(hash, PRIME64_3);
		offset = offset + 4;
		remaining = remaining - 4;
	}
	while (remaining != 0) {
		hash = hash ^ mul((uint64_t)input[offset], PRIME64_5);
		hash = rotl64(hash, 11);
		hash = mul(hash, PRIME64_1);
		++offset;
		--remaining;
	}
	return avalanche(hash);
}
// --- self test ---
#define TEST_DATA_SIZE 101
#define PRIME32_1 0x9E3779B1UL
static int32_t testNum = 0;

__attribute__((always_inline))
static inline uint32_t hi32(uint64_t w) {
	return (uint32_t)(w >> 32);
}

__attribute__((always_inline))
static inline uint32_t lo32(uint64_t w) {
	return (uint32_t)(w & 0xFFFFFFFFUL);
}

static bool testSequence(uint8_t *data, size_t length, uint64_t seed, uint64_t expected) {
	const uint64_t result = xxh64(data, length, seed);
	++testNum;
	if (result != expected) {
		printf("test #%d failed: expected 0x%08X%08X, got 0x%08X%08X\n", testNum, hi32(expected), lo32(expected), hi32(result), lo32(result));
		return false;
	}
	printf("test #%d passed: 0x%08X%08X\n", testNum, hi32(result), lo32(result));
	return true;
}


int main(void) {
	printf("test XXH64\n");
	uint8_t testData[TEST_DATA_SIZE];
	uint32_t byteGen = PRIME32_1;
	size_t i = 0;
	while (i < TEST_DATA_SIZE) {
		testData[i] = byteGen >> 24;
		byteGen = byteGen * byteGen;
		++i;
	}
	uint8_t *const data = (uint8_t *)testData;
	const uint64_t prime = (uint64_t)PRIME32_1;
	bool success = true;
	if (!testSequence(NULL, 0, 0x0, 0xEF46DB3751D8E999ULL)) {
		success = false;
	}
	if (!testSequence(NULL, 0, prime, 0xAC75FDA2929B17EFULL)) {
		success = false;
	}
	if (!testSequence(data, 1, 0x0, 0x4FCE394CC88952D8UL)) {
		success = false;
	}
	if (!testSequence(data, 1, prime, 0x739840CB819FA723UL)) {
		success = false;
	}
	if (!testSequence(data, 14, 0x0, 0xCFFA8DB881BC3A3DULL)) {
		success = false;
	}
	if (!testSequence(data, 14, prime, 0x5B9611585EFCC9CBUL)) {
		success = false;
	}
	if (!testSequence(data, TEST_DATA_SIZE, 0x0, 0x0EAB543384F878ADUL)) {
		success = false;
	}
	if (!testSequence(data, TEST_DATA_SIZE, prime, 0xCAA65939306F1E21ULL)) {
		success = false;
	}
	if (!success) {
		printf("XXH64: FAILED\n");
		return 1;
	}
	printf("XXH64 reference implementation: OK\n");
	return 0;
}

