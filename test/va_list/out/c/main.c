// examples/

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./print.h"





int main()
{
    lf_printf("Hello World!\n");

    const char c = '$';
    char *const s = "Hi!";
    const int32_t i = (int32_t)-1;
    const uint32_t n = 123;
    const uint32_t x = 0x1234567F;

    lf_printf("%% = '%%'\n");
    lf_printf("c = '%c'\n", c);
    lf_printf("s = \"%s\"\n", s);
    lf_printf("i = %i\n", i);
    lf_printf("n = %n\n", n);
    lf_printf("x = 0x%x\n", x);

    return 0;
}

