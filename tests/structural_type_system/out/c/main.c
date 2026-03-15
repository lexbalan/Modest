
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct __anonymous_struct_3 {int32_t x;};
struct __anonymous_struct_4 {int32_t x;};
struct type1 {
	int32_t x;
};
struct type2 {
	int32_t x;
};
typedef struct type1 Type3;
#define ZERO {.x = 0}
// Check by value

static void f1_val(struct type1 x) {
	printf("f1 x.x = %d\n", x.x);
}

static void f2_val(struct type2 x) {
	printf("f2 x.x = %d\n", x.x);
}

static void f3_val(Type3 x) {
	printf("f3 x.x = %d\n", x.x);
}

static void f4_val(struct __anonymous_struct_3 x) {
	printf("f4 x.x = %d\n", x.x);
}
// Check by pointer

static void f1_ptr(struct type1 *x) {
	printf("f1p x.x = %d\n", x->x);
}

static void f2_ptr(struct type2 *x) {
	printf("f2p x.x = %d\n", x->x);
}

static void f3_ptr(Type3 *x) {
	printf("f3p x.x = %d\n", x->x);
}

static void f4_ptr(struct __anonymous_struct_4 *x) {
	printf("f4p x.x = %d\n", x->x);
}
static struct type1 a = (struct type1){.x = 1};
static struct type2 b = (struct type2){.x = 2};
static Type3 c = (Type3){.x = 3};

static void test_by_value(void) {
	f1_val((struct type1){.x = 0});
	f2_val((struct type2){.x = 0});
	f3_val((Type3){.x = 0});
	f4_val((struct __anonymous_struct_3){.x = 0});
	f1_val((struct type1)ZERO);
	f2_val((struct type2)ZERO);
	f3_val((Type3)ZERO);
	f4_val((struct __anonymous_struct_3)ZERO);
	f1_val(a);
	f2_val(RAWCAST(struct type2, struct type1, a));
	f3_val(a);
	f4_val(RAWCAST(struct __anonymous_struct_3, struct type1, a));
	f1_val(RAWCAST(struct type1, struct type2, b));
	f2_val(b);
	f3_val(RAWCAST(Type3, struct type2, b));
	f4_val(RAWCAST(struct __anonymous_struct_3, struct type2, b));
	f1_val(c);
	f2_val(RAWCAST(struct type2, Type3, c));
	f3_val(c);
	f4_val(RAWCAST(struct __anonymous_struct_3, Type3, c));
}

static void test_by_pointer(void) {
	f1_ptr(&a);
	f2_ptr(/*$*/((struct type2 *)&a));
	f3_ptr(/*$*/((Type3 *)&a));
	f4_ptr(/*$*/((struct __anonymous_struct_4 *)&a));
	f1_ptr(/*$*/((struct type1 *)&b));
	f2_ptr(&b);
	f3_ptr(/*$*/((Type3 *)&b));
	f4_ptr(/*$*/((struct __anonymous_struct_4 *)&b));
	f1_ptr(/*$*/((struct type1 *)&c));
	f2_ptr(/*$*/((struct type2 *)&c));
	f3_ptr(&c);
	f4_ptr(/*$*/((struct __anonymous_struct_4 *)&c));
}

int main(void) {
	test_by_value();
	test_by_pointer();
	return 0;
}

