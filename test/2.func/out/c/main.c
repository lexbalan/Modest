// test/2.func/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




// declare function f0
void f0();

// define function f1
void f1()
{
    printf("f1 was called\n");
}


int32_t sum(int32_t a, int32_t b)
{
    return a + b;
}


void print_ab(int32_t a, int32_t b)
{
    printf("print_ab(a=%i, b=%i)\n", a, b);
}


// define function main
int main()
{
    printf("test func\n");
    f0();
    f1();

    // call function with two arguments and return value
    const int32_t arg_a = 1;
    const int32_t arg_b = 2;
    const int32_t sum_result = sum(arg_a, arg_b);
    printf("sum(%i, %i) == %i\n", arg_a, arg_b, sum_result);

    print_ab(10, 20);

    return 0;
}

// define function f0
void f0()
{
    printf("f0 was called\n");
}

