// test/builtin_constants/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
    printf("__compiler.name = %s\n", "m2");
    printf("__compiler.version.major = %u\n", 0);
    printf("__compiler.version.minor = %u\n", 7);

    printf("__target.pointerWidth = %u\n", 64);
    printf("__target.charWidth = %u\n", 8);
    printf("__target.intWidth = %u\n", 32);
    printf("__target.floatWidth = %u\n", 64);

    printf("__platformSystem = \"%s\"\n", "Darwin");
    printf("__platformRelease = \"%s\"\n", "21.6.0");

    return 0;
}

