// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



struct __anonymous_struct_3 {int32_t x;};
struct __anonymous_struct_4 {int32_t x;};


struct main_Type1 {
	int32_t x;
};

struct main_Type2 {
	int32_t x;
};

struct main_Type3 {
	int32_t x;
};
void f0_val(main_Type1 x);
void f1_val(main_Type2 x);
void f2_val(main_Type3 x);
void f3_val(struct __anonymous_struct_3 x);
void f0_ptr(main_Type1 *x);
void f1_ptr(main_Type2 *x);
void f2_ptr(main_Type3 *x);
void f3_ptr(struct __anonymous_struct_4 *x);
void test_by_value();
void test_by_pointer();



static main_Type1 a = {.x = 1};
static main_Type2 b = {.x = 2};
static main_Type3 c = {.x = 3};

void f0_val(main_Type1 x)
{
	printf("f0 x.x = %d\n", x.x);
}

void f1_val(main_Type2 x)
{
	printf("f1 x.x = %d\n", x.x);
}

void f2_val(main_Type3 x)
{
	printf("f2 x.x = %d\n", x.x);
}

void f3_val(struct __anonymous_struct_3 x)
{
	printf("f3 x.x = %d\n", x.x);
}

void f0_ptr(main_Type1 *x)
{
	printf("f0p x.x = %d\n", x->x);
}

void f1_ptr(main_Type2 *x)
{
	printf("f1p x.x = %d\n", x->x);
}

void f2_ptr(main_Type3 *x)
{
	printf("f2p x.x = %d\n", x->x);
}

void f3_ptr(struct __anonymous_struct_4 *x)
{
	printf("f3p x.x = %d\n", x->x);
}

void test_by_value()
{
	f0_val(a);
	f1_val(*(main_Type2 *)&a);
	f2_val(*(main_Type3 *)&a);
	f3_val(*(struct __anonymous_struct_3 *)&a);

	f0_val(*(main_Type1 *)&b);
	f1_val(b);
	f2_val(*(main_Type3 *)&b);
	f3_val(*(struct __anonymous_struct_3 *)&b);

	f0_val(*(main_Type1 *)&c);
	f1_val(*(main_Type2 *)&c);
	f2_val(c);
	f3_val(*(struct __anonymous_struct_3 *)&c);
}

void test_by_pointer()
{
	f0_ptr((main_Type1 *)&a);
	f1_ptr((main_Type2 *)&a);
	f2_ptr((main_Type3 *)&a);
	f3_ptr((struct __anonymous_struct_4 *)&a);

	f0_ptr((main_Type1 *)&b);
	f1_ptr((main_Type2 *)&b);
	f2_ptr((main_Type3 *)&b);
	f3_ptr((struct __anonymous_struct_4 *)&b);

	f0_ptr((main_Type1 *)&c);
	f1_ptr((main_Type2 *)&c);
	f2_ptr((main_Type3 *)&c);
	f3_ptr((struct __anonymous_struct_4 *)&c);
}

int main()
{
	test_by_value();
	test_by_pointer();
	return 0;
}

