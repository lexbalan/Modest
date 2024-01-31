// examples/

#include <string.h>
#include <stdio.h>
#include "./print.h"
#include <stdint.h>
#include <stdbool.h>



int main()
{
    ff_printf("Hello World!\n");

    const char c = '$';
    char *const s = "Hi!";
    const int32_t i = (int32_t)-1;
    const uint32_t n = 123;
    const uint32_t x = 0x1234567F;

    ff_printf("%% = '%%'\n");
    ff_printf("c = '%c'\n", c);
    ff_printf("s = \"%s\"\n", s);
    ff_printf("i = %i\n", i);
    ff_printf("n = %n\n", n);
    ff_printf("x = 0x%x\n", x);

    return 0;
}

