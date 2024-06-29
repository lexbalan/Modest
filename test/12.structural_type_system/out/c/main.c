// test/12.structural_type_system/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
/* forward type declaration */
typedef struct Type1 Type1;
typedef struct Type2 Type2;
typedef struct Type3 Type3;
/* anon recs */
struct __anonymous_struct_3 {int32_t x;};
struct __anonymous_struct_4 {int32_t x;};




struct Type1 {
	int32_t x;
};

struct Type2 {
	int32_t x;
};

struct Type3 {
	int32_t x;
};


void f0_val(Type1 x)
{
	printf("f0 x.x = %d\n", x.x);
}

void f1_val(Type2 x)
{
	printf("f1 x.x = %d\n", x.x);
}

void f2_val(Type3 x)
{
	printf("f2 x.x = %d\n", x.x);
}

void f3_val(struct __anonymous_struct_3 x)
{
	printf("f3 x.x = %d\n", x.x);
}


void f0_ptr(Type1 *x)
{
	printf("f0p x.x = %d\n", x->x);
}

void f1_ptr(Type2 *x)
{
	printf("f1p x.x = %d\n", x->x);
}

void f2_ptr(Type3 *x)
{
	printf("f2p x.x = %d\n", x->x);
}

void f3_ptr(struct __anonymous_struct_4 *x)
{
	printf("f3p x.x = %d\n", x->x);
}


static Type1 a = {.x = 1};
static Type2 b = {.x = 2};
static Type3 c = {.x = 3};



void test_by_value()
{
	f0_val(a);
	f1_val(a);
	f2_val(a);
	f3_val(a);

	f0_val(b);
	f1_val(b);
	f2_val(b);
	f3_val(b);

	f0_val(c);
	f1_val(c);
	f2_val(c);
	f3_val(c);
}


void test_by_pointer()
{
	f0_ptr(&a);
	f1_ptr(&a);
	f2_ptr(&a);
	f3_ptr(&a);

	f0_ptr(&b);
	f1_ptr(&b);
	f2_ptr(&b);
	f3_ptr(&b);

	f0_ptr(&c);
	f1_ptr(&c);
	f2_ptr(&c);
	f3_ptr(&c);
}


int main()
{
	test_by_value();
	test_by_pointer();
	return 0;
}

