// lib/fastfood/delay.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>

// for clock()


void delay_us(uint64_t us)
{
    const uint64_t start_time = clock();
    while (clock() < start_time + us) {
        // just waiting
    }
}


void delay(uint64_t us)
{
    delay_us(us);
}


void delay_ms(uint64_t ms)
{
    delay_us(ms * 1000);
}


void delay_s(uint64_t s)
{
    delay_ms(s * 1000);
}
