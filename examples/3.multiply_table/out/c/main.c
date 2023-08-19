
#include <stdio.h>
#include <stdint.h>
#include <string.h>


// examples/multiply_table/main.cm

void mtab(int n)
{
    int m = 1;
    while (m < 10) {
        const int nm = n * m;
        printf("%d * %d = %d\n", n, m, nm);
        m = m + 1;
    }
}

int main(void)
{
    const unsigned int n = 2U;
    printf("multiply table for %d\n", n);
    mtab(n);
    return 0;
}

