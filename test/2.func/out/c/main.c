// test/2.func/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




// declare function f0
void f0(void);

// define function f1
void f1(void)
{
    printf("f1 was called\n");
}

// define function main
int main(void)
{
    printf("test func\n");
    f0();
    f1();
    return 0;
}

// define function f0
void f0(void)
{
    printf("f0 was called\n");
}

