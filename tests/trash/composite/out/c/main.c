
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
struct __anonymous_struct_3 {int32_t x; int32_t y;};
// Test for composite types
static int32_t *main_p0;
static int32_t **main_p1;

static void main_f0(void) {
	return;
}

static int32_t main_f1(int32_t x) {
	return x;
}

static int32_t main_f2(int32_t a, int32_t b) {
	return a + b;
}

static int32_t *main_f3(void) {
	return NULL;
}

static void main_f4(int32_t x, int32_t __out[10]) {
	__builtin_memcpy(__out, &(int32_t [10]){1, 2, 3}, sizeof(int32_t [10]));
}

static void main_f5(int32_t _a[32], int32_t __out[32]) {
	int32_t a[32];
	__builtin_memcpy(a, _a, sizeof(int32_t [32]));
	__builtin_memcpy(__out, &a, sizeof(int32_t [32]));
}

static int32_t (*main_f6(int32_t a[32]))[32] {
	return NULL;
}

static void main_f7(void (*f)(void)) {
	return;
}

static void (*main_f8(void (*f)(void)))(void) {
	return &main_f0;
}

static void (**main_f9(void (*f)(void)))(void) {
	return NULL;
}

static void (**main_f10(void (**f)(void)))(void) {
	return f;
}

static void (**main_f11(int32_t (*(**f)(int32_t a, int32_t *b))[10]))(void) {
	return NULL;
}

static void (**main_f12(int32_t (*(**f)(int32_t a[32], int32_t (**b)[64]))[10]))(void) {
	return NULL;
}

static void (**main_f13(int32_t (*(**f)(int32_t *a[32], int32_t *(**b)[64]))[10]))(void) {
	return NULL;
}
static void (*main_pf0)(void) = &main_f0;
static int32_t (*main_pf1)(int32_t x) = &main_f1;
static int32_t (*main_pf2)(int32_t a, int32_t b) = &main_f2;
static int32_t *(*main_pf3)(void) = &main_f3;
static void (*main_pf4)(int32_t x, int32_t __out[10]) = &main_f4;
static void (*main_pf5)(int32_t _a[32], int32_t __out[32]) = &main_f5;
static int32_t (*(*main_pf6)(int32_t a[32]))[32] = &main_f6;
static void (*main_pf7)(void (*f)(void)) = &main_f7;
static void (*(*main_pf8)(void (*f)(void)))(void) = &main_f8;
static void (**(*main_pf9)(void (*f)(void)))(void) = &main_f9;
static void (**(*main_pf10)(void (**f)(void)))(void) = &main_f10;
static void (**(*main_pf11)(int32_t (*(**f)(int32_t a, int32_t *b))[10]))(void) = &main_f11;
static void (**(*main_pf12)(int32_t (*(**f)(int32_t a[32], int32_t (**b)[64]))[10]))(void) = &main_f12;
static void (**(*main_pf13)(int32_t (*(**f)(int32_t *a[32], int32_t *(**b)[64]))[10]))(void) = &main_f13;
static int32_t main_a0[5] = {0, 1, 2, 3, 4};
static int32_t *main_a1[5] = {&main_a0[0], &main_a0[1], &main_a0[2], &main_a0[3], &main_a0[4]};
static int32_t **main_a2[5] = {&main_a1[0], &main_a1[1], &main_a1[2], &main_a1[3], &main_a1[4]};
static void (*main_a3[5])(void) = {&main_f0};
static int main_a4[2][5] = {{0, 1, 2, 3, 4}, {5, 6, 7, 8, 9}};
static int (*main_a5[2])[5] = {&main_a4[0], &main_a4[1]};
// Проблема в том что мой getelementptr не умеет в цепь-молнию
// а здесь без нее никак... придется взяться за это и сделать наконец
//var a6: [2][5]*Int = [
//	[&a4[0][0], &a4[0][1], &a4[0][2], &a4[0][3], &a4[0][4]]
//	[&a4[1][0], &a4[1][1], &a4[1][2], &a4[1][3], &a4[1][4]]
//]
static int (*main_a7[2][5])[5] = {
	{&main_a0, &main_a0, &main_a0, &main_a0, &main_a0},
	{&main_a0, &main_a0, &main_a0, &main_a0, &main_a0}
};
static int (*(*main_a8[2][5])[2][5])[5] = {
	{&main_a7, &main_a7, &main_a7, &main_a7, &main_a7},
	{&main_a7, &main_a7, &main_a7, &main_a7, &main_a7}
};
static int (*(*(*main_a9[5])[10])[2])(int a);
static int32_t (*main_p2)[5] = &main_a0;
static int32_t (**main_p3)[5] = &main_p2;
struct main_rgb24 {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
};
static struct main_rgb24 main_rgb0[2] = {
	(struct main_rgb24){.red = 200, .green = 0, .blue = 0},
	(struct main_rgb24){.red = 200, .green = 0, .blue = 0}
};
struct main_animation_point {
	struct main_rgb24 color;
	uint32_t time;
};
static struct main_animation_point main_ap = (struct main_animation_point){
	.color = {
		.red = 200,
		.green = 0,
		.blue = 0
	},
	.time = 3000
};
static struct main_animation_point main_animation0_points[5] = {
	(struct main_animation_point){.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	(struct main_animation_point){.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	(struct main_animation_point){.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	(struct main_animation_point){.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	(struct main_animation_point){.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};
static struct main_animation_point main_animation1_points[5] = {
	(struct main_animation_point){.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	(struct main_animation_point){.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	(struct main_animation_point){.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	(struct main_animation_point){.color = {.red = 254, .green = 254, .blue = 0}, .time = 20},
	(struct main_animation_point){.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};
static struct main_animation_point main_animation2_points[5] = {
	(struct main_animation_point){.color = {.red = 200, .green = 0, .blue = 0}, .time = 3},
	(struct main_animation_point){.color = {.red = 0, .green = 200, .blue = 0}, .time = 30},
	(struct main_animation_point){.color = {.red = 100, .green = 100, .blue = 0}, .time = 300},
	(struct main_animation_point){.color = {.red = 255, .green = 254, .blue = 0}, .time = 20},
	(struct main_animation_point){.color = {.red = 0, .green = 0, .blue = 255}, .time = 3000}
};

static void main_xy(struct __anonymous_struct_3 x) {
}
static int32_t main_arrr[3][3] = {
	{1, 2, 3},
	{4, 5, 6},
	{7, 8, 9}
};
static void (*main_arry[3][3])(void);

static int32_t main_add(int32_t a, int32_t b) {
	return a + b;
}

static int32_t main_sub(int32_t a, int32_t b) {
	return a - b;
}
static int32_t (*main_farr[2])(int32_t a, int32_t b) = {
	&main_add, &main_sub
};
typedef void main_He(void);

__attribute__((used))
static void main_he(main_He *x) {
	(void)x;
}

static void main_hi(char *x) {
	printf("Hi %s!\n", x);
}
static void (*main_hiarr[10])(char *x) = {
	&main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi, &main_hi
};
struct main_wrap {
	void (*fhi)(char *x);
	int32_t (*fop)(int32_t a, int32_t b);
};
static struct main_wrap main_wrap0 = (struct main_wrap){
	.fhi = &main_hi,
	.fop = &main_add
};
static struct main_wrap *main_awrap[2] = {&main_wrap0, &main_wrap0};

int32_t main(void) {
	main_xy((struct __anonymous_struct_3){.x = 10, .y = 20});
	printf("test1 (eq): ");
	if (__builtin_memcmp(&main_animation0_points, &main_animation1_points, sizeof(struct main_animation_point [5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}
	printf("test2 (ne): ");
	if (__builtin_memcmp(&main_animation1_points, &main_animation2_points, sizeof(struct main_animation_point [5])) == 0) {
		printf("eq\n");
	} else {
		printf("ne\n");
	}
	uint32_t i = 0U;
	while (i < 3U) {
		uint32_t j = 0U;
		while (j < 3U) {
			printf("arrr[%d][%d] = %d\n", i, j, main_arrr[i][j]);
			j = j + 1U;
		}
		i = i + 1U;
	}
	const int32_t _add = main_farr[0](5, 7);
	printf("farr[0](5, 7) = %d\n", _add);
	const int32_t _sub = main_farr[1](5, 7);
	printf("farr[1](5, 7) = %d\n", _sub);
	i = 0U;
	while (i < 10U) {
		main_hiarr[i]("LOL");
		i = i + 1U;
	}
	main_awrap[0]->fhi("World");
	return 0;
}

