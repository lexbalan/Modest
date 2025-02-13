
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"

/* anonymous records */
struct __anonymous_struct_2 {int32_t x;
};
struct __anonymous_struct_3 {int32_t x;
};


struct main_Type1 {
	int32_t x;
};
typedef struct main_Type1 main_Type1;

struct main_Type2 {
	int32_t x;
};
typedef struct main_Type2 main_Type2;

typedef main_Type1 main_Type3;


static void main_f0_val(main_Type1 x)
{
	printf("f0 x.x = %d\n", x.x);
}

static void main_f1_val(main_Type2 x)
{
	printf("f1 x.x = %d\n", x.x);
}

static void main_f2_val(main_Type3 x)
{
	printf("f2 x.x = %d\n", x.x);
}

static void main_f3_val(struct __anonymous_struct_2 x)
{
	printf("f3 x.x = %d\n", x.x);
}


static void main_f0_ptr(main_Type1 *x)
{
	printf("f0p x.x = %d\n", x->x);
}

static void main_f1_ptr(main_Type2 *x)
{
	printf("f1p x.x = %d\n", x->x);
}

static void main_f2_ptr(main_Type3 *x)
{
	printf("f2p x.x = %d\n", x->x);
}

static void main_f3_ptr(struct __anonymous_struct_3 *x)
{
	printf("f3p x.x = %d\n", x->x);
}


static main_Type1 main_a = {.x = 1};
static main_Type2 main_b = {.x = 2};
static main_Type3 main_c = {.x = 3};



static void main_test_by_value()
{
	main_f0_val(main_a);
	main_f1_val(*(main_Type2*)&main_a);
	main_f2_val(main_a);
	main_f3_val(*(struct __anonymous_struct_2*)&main_a);

	main_f0_val(*(main_Type1*)&main_b);
	main_f1_val(main_b);
	main_f2_val(*(main_Type3*)&main_b);
	main_f3_val(*(struct __anonymous_struct_2*)&main_b);

	main_f0_val(main_c);
	main_f1_val(*(main_Type2*)&main_c);
	main_f2_val(main_c);
	main_f3_val(*(struct __anonymous_struct_2*)&main_c);
}


static void main_test_by_pointer()
{
	main_f0_ptr(&main_a);
	main_f1_ptr((main_Type2 *)&main_a);
	main_f2_ptr((main_Type3 *)&main_a);
	main_f3_ptr((struct __anonymous_struct_3 *)&main_a);

	main_f0_ptr((main_Type1 *)&main_b);
	main_f1_ptr(&main_b);
	main_f2_ptr((main_Type3 *)&main_b);
	main_f3_ptr((struct __anonymous_struct_3 *)&main_b);

	main_f0_ptr((main_Type1 *)&main_c);
	main_f1_ptr((main_Type2 *)&main_c);
	main_f2_ptr(&main_c);
	main_f3_ptr((struct __anonymous_struct_3 *)&main_c);
}


int main()
{
	main_test_by_value();
	main_test_by_pointer();
	return 0;
}

