
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define ARRCPY(dst, src, len) \
	do { \
		uint32_t _len = (uint32_t)(len); \
		for (uint32_t _i = 0; _i < _len; _i++) { \
			(*(dst))[_i] = (*(src))[_i]; \
		} \
	} while (0)
#include <stdlib.h>

static void main_array_print(int32_t pa[], uint32_t len) {
	uint32_t i = 0U;
	while (i < len) {
		printf("a[%d] = %d\n", i, pa[i]);
		i = i + 1U;
	}
}

static void main_array4intInc(int32_t _a[4], int32_t __out[4]) {
	int32_t a[4];
	__builtin_memcpy(a, _a, sizeof(int32_t [4]));
	__builtin_memcpy(__out, &(int32_t [4]){a[0] + 1, a[1] + 1, a[2] + 1, a[3] + 1}, sizeof(int32_t [4]));
}

static void main_checkParamsIo(void) {
	printf("checkParamsIo\n");
	int32_t a[8] = {0, 1, 2, 3, 4, 5, 6, 7};
	main_array4intInc((int32_t *)(int32_t (*)[4 - 0])&a[0], (int32_t *)(int32_t (*)[4 - 0])&a[0]);
	main_array4intInc((int32_t *)(int32_t (*)[8 - 4])&a[4], (int32_t *)(int32_t (*)[8 - 4])&a[4]);
	main_array_print((int32_t *)&a, 8U);
}

int main(void) {
	printf("test slices\n");
	main_checkParamsIo();
	printf("--------------------------------------------\n");
	int32_t a[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	int32_t main_s1[2 - 1];
	__builtin_memcpy(&main_s1, (int32_t (*)[2 - 1])&a[1], sizeof(const int32_t [2 - 1]));
	uint32_t i = 0U;
	while (i < LENGTHOF(main_s1)) {
		printf("s1[%d] = %d\n", i, main_s1[i]);
		i = i + 1U;
	}
	printf("--------------------------------------------\n");
	int32_t (*const main_pa)[10] = &a;
	int32_t main_s2[8 - 5];
	__builtin_memcpy(&main_s2, (int32_t (*)[8 - 5])&(*main_pa)[5], sizeof(const int32_t [8 - 5]));
	i = 0U;
	while (i < LENGTHOF(main_s2)) {
		printf("s2[%d] = %d\n", i, main_s2[i]);
		i = i + 1U;
	}
	printf("--------------------------------------------\n");
	int32_t vs1[2 - 1];
	__builtin_memcpy(&vs1, &main_s1, sizeof(int32_t [2 - 1]));
	int32_t vs2[8 - 5];
	__builtin_memcpy(&vs2, &main_s2, sizeof(int32_t [8 - 5]));
	#define main_ax 2
	#define main_bx 6
	ARRCPY((int32_t (*)[main_bx - main_ax])&a[main_ax], ((&(int8_t [4]){10, 20, 30, 40})), main_bx - main_ax);
	i = 0U;
	while (i < LENGTHOF(a)) {
		printf("a[%d] = %d\n", i, a[i]);
		i = i + 1U;
	}
	printf("--------------------------------------------\n");
	int32_t s[10] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
	__builtin_bzero((int32_t (*)[5 - 2])&s[2], sizeof(int32_t [5 - 2]));
	i = 0U;
	while (i < LENGTHOF(s)) {
		printf("s[%d] = %d\n", i, (uint32_t)abs(s[i]));
		i = i + 1U;
	}
	printf("--------------------------------------------\n");
	printf("test pointer to slice\n");
	#define main_aa 2
	#define main_bb 8
	int32_t (*const main_p)[main_bb - main_aa] = (int32_t (*)[main_bb - main_aa])&s[main_aa];
	main_array_print((int32_t *)main_p, LENGTHOF(*main_p));
	printf("--------------------------------------------\n");
	(*main_p)[0] = 123;
	main_array_print((int32_t *)main_p, LENGTHOF(*main_p));
	printf("--------------------------------------------\n");
	printf("slice of pointer to open array\n");
	int32_t (*pw)[] = (int32_t (*)[])&s;
	printf("before\n");
	main_array_print((int32_t *)pw, 10U);
	int32_t ind = 1;
	pw = (int32_t (*)[])&(*pw)[ind];
	printf("after\n");
	main_array_print((int32_t *)pw, 10U);
	printf("--------------------------------------------\n");
	printf("zero slice by var\n");
	int32_t ss[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	int32_t k = 4;
	int32_t j = 7;
	__builtin_bzero((int32_t (*)[j - k])&ss[k], sizeof(int32_t [j - k]));
	main_array_print((int32_t *)&ss, 10U);
	printf("--------------------------------------------\n");
	printf("copy slice by var\n");
	int32_t src[5] = {10, 20, 30, 40, 50};
	int32_t dst[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	#define main_i1 3
	#define main_j1 8
	ARRCPY((int32_t (*)[main_j1 - main_i1])&dst[main_i1], ((&(int8_t [5]){11, 22, 33, 44, 55})), main_j1 - main_i1);
	main_array_print((int32_t *)&dst, 10U);
	return 0;
	#undef main_ax
	#undef main_bx
	#undef main_aa
	#undef main_bb
	#undef main_i1
	#undef main_j1
}

