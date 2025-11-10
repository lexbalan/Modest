
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



int32_t main(void) {
	printf("test2\n");

	const datetime_DateTime dt = datetime_dateTimeNow();

	printf("dateTimeNow = {\n");
	printf("\tdate = {\n");
	printf("\t\tyear = %d\n", dt.date.year);
	printf("\t\tmonth = %d\n", dt.date.month);
	printf("\t\tday = %d\n", dt.date.day);
	printf("\t}\n");
	printf("\ttime = {\n");
	printf("\t\thour = %d\n", dt.time.hour);
	printf("\t\tminute = %d\n", dt.time.minute);
	printf("\t\tsecond = %d\n", dt.time.second);
	printf("\t}\n");
	printf("}\n");


	char dateTimeStr[32];
	datetime_sprintDateTime((char *)&dateTimeStr);
	printf("dt = '%s'\n", (char *)&dateTimeStr);


	return 0;
}


