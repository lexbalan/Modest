// test/ctime_test/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <time.h>
#include <unistd.h>




static int cnt;


int main()
{
    printf("ctime test\n");

    time_t timer;
    struct tm y2k;
    struct tm *tm;
    double sec;

    y2k.tm_hour = 0;y2k.tm_min = 0;y2k.tm_sec = 0;
    y2k.tm_year = 100;y2k.tm_mon = 0;y2k.tm_mday = 1;

    //timer = clock()
    time(&timer);

    sec = difftime(timer, mktime(&y2k));

    printf("%.f seconds since January 1, 2000 in the current timezone\n", sec);

    tm = gmtime(&timer);

    printf("tm.year = %i\n", tm->tm_year + 1900);
    printf("tm.month = %i\n", tm->tm_mon);
    printf("tm.mday = %i\n", tm->tm_mday);
    printf("tm.wday = %i\n", tm->tm_wday);
    printf("tm.hour = %i\n", tm->tm_hour);
    printf("tm.min = %i\n", tm->tm_min);
    printf("tm.sec = %i\n", tm->tm_sec);

    return 0;
}

