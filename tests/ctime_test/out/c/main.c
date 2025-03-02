// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"












int main()
{
	printf("ctime test\n");

	const time_t seconds = time(NULL);
	printf("Hours since January 1, 1970 = %ld\n", seconds / 3600);

	struct tm y2k;
	struct tm *tm;
	double sec;

	y2k.tm_hour = 0;y2k.tm_min = 0;y2k.tm_sec = 0;
	y2k.tm_year = 100;y2k.tm_mon = 0;y2k.tm_mday = 1;

	//timer = clock()
	time_t timer;
	time(&timer);

	sec = difftime(timer, mktime((struct tm *)&y2k));
	printf("%.f seconds since January 1, 2000 in the current timezone\n", sec);


	/*var t: TimeT
	t = time(nil)
	printf("t = %i\n", t)

	var t2: TimeT
	time(&t2)
	printf("t2 = %i\n", t2)*/


	time_t time2;
	time(&time2);
	//time2 = time(nil)   // segfail
	tm = (struct tm *)localtime(&time2);
	//tm = gmtime(&time2)

	printf("tm.year = %i\n", tm->tm_year + 1900);
	printf("tm.month = %i\n", tm->tm_mon + 1);
	printf("tm.mday = %i\n", tm->tm_mday);
	printf("tm.wday = %i\n", tm->tm_wday);
	printf("tm.hour = %i\n", tm->tm_hour);
	printf("tm.min = %i\n", tm->tm_min);
	printf("tm.sec = %i\n", tm->tm_sec);

	printf("");

	const datetime_DateTime now = datetime_dateTimeNow();
	printf("now.year = %i\n", now.year);
	printf("now.month = %i\n", now.month);
	printf("now.day = %i\n", now.day);
	printf("now.hour = %i\n", now.hour);
	printf("now.minute = %i\n", now.minute);
	printf("now.second = %i\n", now.second);

	return 0;
}

