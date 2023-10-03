
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/12.structural_type_system/main.cm

typedef struct {
    int32_t x;
} Type1;

typedef struct {
    int32_t x;
} Type2;


typedef Type1 Type3;


void f0(Type1 x)
{
    printf("f0 x.x = %d\n", x.x);
}

void f1(Type2 x)
{
    printf("f1 x.x = %d\n", x.x);
}

void f2(Type3 x)
{
    printf("f2 x.x = %d\n", x.x);
}

void f3(struct {    int32_t x;
} x)
{
    printf("f3 x.x = %d\n", x.x);
}


void f0p(Type1 *x)
{
    printf("f0p x.x = %d\n", x->x);
}

void f1p(Type2 *x)
{
    printf("f1p x.x = %d\n", x->x);
}

void f2p(Type3 *x)
{
    printf("f2p x.x = %d\n", x->x);
}

void f3p(struct {    int32_t x;
} *x)
{
    printf("f3p x.x = %d\n", x->x);
}


static Type1 a = (Type1){.x = 1};
static Type2 b = (Type2){.x = 2};
static Type3 c = (Type3){.x = 3};


void test_by_value(void)
{
    f0(a);
    f1(*((Type2 *)&a));
    f2(*((Type3 *)&a));
    //f3(a)

    f0(*((Type1 *)&b));
    f1(b);
    f2(*((Type3 *)&b));
    //f3(b)

    f0(*((Type1 *)&c));
    f1(*((Type2 *)&c));
    f2(c);
    //f3(c)
}

void test_by_pointer(void)
{
    f0p((Type1 *)&a);
    f1p((Type2 *)&a);
    f2p((Type3 *)&a);
    //f3p(&a)

    f0p((Type1 *)&b);
    f1p((Type2 *)&b);
    f2p((Type3 *)&b);
    //f3p(&b)

    f0p((Type1 *)&c);
    f1p((Type2 *)&c);
    f2p((Type3 *)&c);
    //f3p(&c)
}


int main(void)
{
    test_by_value();
    test_by_pointer();
    return 0;
}

