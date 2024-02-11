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

// define function main
int main()
{
    printf("test func\n");
    f0();
    f1();
    return 0;
}

// define function f0
void f0()
{
    printf("f0 was called\n");
}

