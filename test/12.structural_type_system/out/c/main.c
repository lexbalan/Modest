
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// test/12.structural_type_system/main.cm

typedef struct {
    int32_t x;
} Type1;

typedef struct {
    int32_t x;
} Type2;


typedef Type1 Type3;


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

void f3_val(struct {    int32_t x;
} x)
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

void f3_ptr(struct {    int32_t x;
} *x)
{
    printf("f3p x.x = %d\n", x->x);
}


Type1 a = (Type1) {.x = 1};
Type2 b = (Type2) {.x = 2};
Type3 c = (Type3) {.x = 3};



void test_by_value(void)
{
    f0_val(a);
    f1_val(*(Type2 *)&a);
    f2_val(*(Type3 *)&a);
    //f3_val(a)

    f0_val(*(Type1 *)&b);
    f1_val(b);
    f2_val(*(Type3 *)&b);
    //f3_val(b)

    f0_val(*(Type1 *)&c);
    f1_val(*(Type2 *)&c);
    f2_val(c);
    //f3_val(c)
}


void test_by_pointer(void)
{
    f0_ptr((Type1 *)&a);
    f1_ptr((Type2 *)&a);
    f2_ptr((Type3 *)&a);
    //f3_ptr(&a)

    f0_ptr((Type1 *)&b);
    f1_ptr((Type2 *)&b);
    f2_ptr((Type3 *)&b);
    //f3_ptr(&b)

    f0_ptr((Type1 *)&c);
    f1_ptr((Type2 *)&c);
    f2_ptr((Type3 *)&c);
    //f3_ptr(&c)
}


int main(void)
{
    test_by_value();
    test_by_pointer();
    return 0;
}

