
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/multiply_table/main.cm


void mtab(int n)
{
    //var m : Nat32
    //m := 1
    int m = 1;
    while (m < 10) {
        int nm = n * m;
        printf("%d * %d = %d\n", n, m, nm);
        m = m + 1;
    }
}


int main(void)
{
    const int8_t n = 4;
    printf("multiply table for %d\n", 4);
    mtab(4);
    return 0;
}

