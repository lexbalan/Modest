
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
static int32_t v[5][4] = {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}};
static int32_t u[5][4] = {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}};
static char *s[4] = {"abc", "def", "gefhk", "l"};
static char s2[4][5] = {{'a', 'b', 'c'}, {'d', 'e', 'f'}, {'g', 'e', 'f', 'h', 'k'}, {'l'}};
static char str1[3] = {'a', 'b', 'c'};
static char a2[2][3] = {{'a', 'b', 'c'}, {'d', 'e', 'f'}};
static char str2[3] = {'a', 'b', 'c'};
#define CV {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}}
#define CU {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}}
#define CS {"abc", "def", "gefhk", "l"}
#define CS2 {{'a', 'b', 'c'}, {'d', 'e', 'f'}, {'g', 'e', 'f', 'h', 'k'}, {'l'}}
#define CSTR1 {'a', 'b', 'c'}
#define CA2 {{'a', 'b', 'c'}, {'d', 'e', 'f'}}
#define CSTR2 {'a', 'b', 'c'}
static char str3[3] = {'a', 'b', 'c'};
typedef bool Success;
#define SUCCESS ((Success)true)
#define FAILURE ((Success)false)
#define CX_1 1
#define CX_2 0xFFFFFFFFUL
#define CX_3 0x3FFFFFFF
#define CW32 ((uint32_t)0x1)
#define CW64 ((uint64_t)0x1)
#define CW32_2 ((uint32_t)1)
#define CW64_2 ((uint64_t)1)
#define CN32 ((uint32_t)1)
#define CN64 ((uint64_t)1)
#define CN32_2 ((uint32_t)1)
#define CN64_2 ((uint64_t)1)
#define CI32_2 ((int32_t)1)
#define CI64_2 ((int64_t)1)
static uint32_t ik = 1;
#define CD (CW32 | 0x1)
#define CD2 CW32
#define CONST7 ((uint32_t)0x0000FFFF)
#define CONST8 ((uint32_t)0x0000FFFF)

static int32_t suffixText(void) {
	if (CW64 << 63 != 0x8000000000000000ULL) {
		return 1;
	}
	if ((uint64_t)CX_1 << 63 != 0x8000000000000000ULL) {
		return 2;
	}
	if ((uint64_t)1 << 63 != 0x8000000000000000ULL) {
		return 3;
	}
	if ((uint32_t)1 << 31 != 0x80000000UL) {
		return 4;
	}
	return 0;
}

static Success suc(void) {
	return SUCCESS;
}

static bool memoryTest(void);

int32_t main(void) {
	printf("suffixText() == %d\n", suffixText());
	const Success success = suc();
	if (__builtin_memcmp(&u, &v, sizeof(int32_t [5][4])) == 0) {
		printf("u == v\n");
	}
	__builtin_memcpy(&v, &(int32_t [5][4])CV, sizeof(int32_t [5][4]));
	__builtin_memcpy(&u, &(int32_t [5][4])CU, sizeof(int32_t [5][4]));
	__builtin_memcpy(&s, &(char *const [4])CS, sizeof(char *[4]));
	__builtin_memcpy(&s2, &(char [4][5])CS2, sizeof(char [4][5]));
	__builtin_memcpy(&str1, &(const char [3])CSTR2, sizeof(char [3]));
	__builtin_memcpy(&a2, &(char [2][3])CA2, sizeof(char [2][3]));
	#define a 5
	#define b 6
	#define c 7
	#define arr {a, b, c}
	int32_t arr2[3] = {a, b, c};
	printf("memoryTest = %d\n", memoryTest());
	return (int32_t)0;
	#undef a
	#undef b
	#undef c
	#undef arr
}

static bool testRegion(uint8_t mem[], uint32_t size, uint8_t pattern);

static bool memoryTest(void) {
	#define memorySize ((int32_t)((int32_t)1024 * (int32_t)1024) * (int32_t)100)
	uint8_t (*const memory)[memorySize] = (uint8_t (*)[memorySize])__builtin_memcpy(malloc(sizeof(uint8_t [memorySize])), &(uint8_t [memorySize]){0}, sizeof(uint8_t [memorySize]));
	volatile uint8_t (*const mem)[memorySize] = (volatile uint8_t (*)[memorySize])memory;
	if (mem == NULL) {
		printf("cannot allocate memory\n");
		return false;
	}
	uint8_t pattern;
	uint8_t i = 0;
	#define nPatterns 12
	while (i < nPatterns) {
		uint8_t pattern = 0x00;
		if (i < 8) {
			pattern = (uint8_t)1 << i;
		} else if (i == 8) {
			pattern = 0x00;
		} else if (i == 9) {
			pattern = 0x55;
		} else if (i == 10) {
			pattern = 0xAA;
		} else {
			pattern = 0xFF;
		}
		printf("check pattern = 0x%02x\n", pattern);
		if (!testRegion((uint8_t *)mem, memorySize, pattern)) {
			return false;
		}
		i = i + 1;
	}
	return true;
	#undef memorySize
	#undef nPatterns
}

static bool testRegion(uint8_t mem[], uint32_t size, uint8_t pattern) {
	uint32_t i = 0;
	while (i < size) {
		mem[i] = pattern;
		i = i + 1;
	}
	i = 0;
	while (i < size) {
		if (mem[i] != pattern) {
			return false;
		}
		i = i + 1;
	}
	return true;
}

