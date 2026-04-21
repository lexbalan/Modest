
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
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

int32_t main(void) {
	if (__builtin_memcmp(&u, &v, sizeof(int32_t [5][4])) == 0) {
		printf("u == v\n");
	}
	__builtin_memcpy(&v, &(int32_t [5][4])CV, sizeof(int32_t [5][4]));
	__builtin_memcpy(&u, &(int32_t [5][4])CU, sizeof(int32_t [5][4]));
	__builtin_memcpy(&s, &(char *const [4])CS, sizeof(char *[4]));
	__builtin_memcpy(&s2, &(char [4][5])CS2, sizeof(char [4][5]));
	__builtin_memcpy(&str1, &(const char [3])CSTR2, sizeof(char [3]));
	__builtin_memcpy(&a2, &(char [2][3])CA2, sizeof(char [2][3]));
	int32_t i;
	if (i > 0) {
	}
	return 0;
}

