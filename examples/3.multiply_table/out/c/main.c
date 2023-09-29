
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/3.multiply_table/main.cm


void mtab(int n)
{
    //var m : Nat32
    //m := 1
    int m = 1;
    while (m < 10) {
        const int nm = n * m;
        printf((const char *)"%d * %d = %d\n", n, m, nm);
        m = m + 1;
    }
}


int main(void)
{
    const int8_t n = 2 * 2;
    printf((const char *)"multiply table for %d\n", n);
    mtab(n);
    return 0;
}

