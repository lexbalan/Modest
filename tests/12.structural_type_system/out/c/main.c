
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



/* anonymous records */
struct __anonymous_struct_3 {
	int32_t x;
};
struct __anonymous_struct_4 {
	int32_t x;
};

struct Type1 {
	int32_t x;
};
typedef struct Type1 Type1;

struct Type2 {
	int32_t x;
};
typedef struct Type2 Type2;

typedef Type1 Type3;

static void f0_val(Type1 x) {
	printf("f0 x.x = %d\n", x.x);
}


static void f1_val(Type2 x) {
	printf("f1 x.x = %d\n", x.x);
}


static void f2_val(Type3 x) {
	printf("f2 x.x = %d\n", x.x);
}


static void f3_val(struct __anonymous_struct_3 x) {
	printf("f3 x.x = %d\n", x.x);
}


static void f0_ptr(Type1 *x) {
	printf("f0p x.x = %d\n", x->x);
}


static void f1_ptr(Type2 *x) {
	printf("f1p x.x = %d\n", x->x);
}


static void f2_ptr(Type3 *x) {
	printf("f2p x.x = %d\n", x->x);
}


static void f3_ptr(struct __anonymous_struct_4 *x) {
	printf("f3p x.x = %d\n", x->x);
}


static Type1 a = {.x = 1};
static Type2 b = {.x = 2};
static Type3 c = {.x = 3};

static void test_by_value(void) {
	f0_val(a);
	f1_val(*(Type2*)&a);
	f2_val(a);
	f3_val(*(struct __anonymous_struct_3*)&a);

	f0_val(*(Type1*)&b);
	f1_val(b);
	f2_val(*(Type3*)&b);
	f3_val(*(struct __anonymous_struct_3*)&b);

	f0_val(c);
	f1_val(*(Type2*)&c);
	f2_val(c);
	f3_val(*(struct __anonymous_struct_3*)&c);
}


static void test_by_pointer(void) {
	f0_ptr(&a);
	f1_ptr((Type2 *)&a);
	f2_ptr((Type3 *)&a);
	f3_ptr((struct __anonymous_struct_4 *)&a);

	f0_ptr((Type1 *)&b);
	f1_ptr(&b);
	f2_ptr((Type3 *)&b);
	f3_ptr((struct __anonymous_struct_4 *)&b);

	f0_ptr((Type1 *)&c);
	f1_ptr((Type2 *)&c);
	f2_ptr(&c);
	f3_ptr((struct __anonymous_struct_4 *)&c);
}


int main(void) {
	test_by_value();
	test_by_pointer();
	return 0;
}


