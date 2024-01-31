// examples/3.multiply_table/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>


void mtab(int n)
{
    //var m : Nat32
    //m := 1
    int32_t m = 1;
    while (m < 10) {
        const int nm = n * m;
        printf("%d * %d = %d\n", n, m, nm);
        m = m + 1;
    }
}


int main()
{
    const int8_t n = 2 * 2;
    printf("multiply table for %d\n", (int32_t)n);
    mtab(n);
    return 0;
}

