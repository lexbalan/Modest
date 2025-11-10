
#include "datetime.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>
#include <stdio.h>

#include <stdlib.h>


static struct tm localTimeNow(void) {
	time_t t;
	time(&t);
	struct tm tm;
	struct tm *const tm2 = localtime_r(&t, &tm);
	return tm;
}


datetime_Time datetime_timeNow(void) {
	const struct tm tm = localTimeNow();
	return (datetime_Time){
		.hour = (uint8_t)abs((int)tm.tm_hour),
		.minute = (uint8_t)abs((int)tm.tm_min),
		.second = (uint8_t)abs((int)tm.tm_sec)
	};
}


datetime_Date datetime_dateNow(void) {
	const struct tm tm = localTimeNow();
	return (datetime_Date){
		.year = (uint32_t)abs((int)tm.tm_year) + 1900,
		.month = (uint8_t)abs((int)tm.tm_mon) + 1,
		.day = (uint8_t)abs((int)tm.tm_mday)
	};
}


datetime_DateTime datetime_dateTimeNow(void) {
	const struct tm tm = localTimeNow();
	return (datetime_DateTime){
		.date = {
			.year = (uint32_t)abs((int)tm.tm_year) + 1900,
			.month = (uint8_t)abs((int)tm.tm_mon) + 1,
			.day = (uint8_t)abs((int)tm.tm_mday)
		},
		.time = {
			.hour = (uint8_t)abs((int)tm.tm_hour),
			.minute = (uint8_t)abs((int)tm.tm_min),
			.second = (uint8_t)abs((int)tm.tm_sec)
		}
	};
}


uint32_t datetime_dayOfYear(void) {
	const struct tm tm = localTimeNow();
	return (uint32_t)abs((int)tm.tm_yday);
}


uint8_t datetime_dayOfWeek(void) {
	const struct tm tm = localTimeNow();
	return (uint8_t)abs((int)tm.tm_wday);
}


int32_t datetime_sprintDate(char *s) {
	const datetime_DateTime dt = datetime_dateTimeNow();
	return sprintf(s, "%d-%02d-%02d",
		dt.date.year,
		dt.date.month,
		dt.date.day
	);
}


int32_t datetime_sprintTime(char *s) {
	const datetime_DateTime dt = datetime_dateTimeNow();
	return sprintf(s, "%02d:%02d:%02d",
		dt.time.hour,
		dt.time.minute,
		dt.time.second
	);
}


int32_t datetime_sprintDateTime(char *s) {
	const char delimiter = ' ';
	const int32_t x0 = datetime_sprintDate(&s[0]);
	s[x0] = delimiter;
	const int32_t x1 = datetime_sprintTime(&s[x0 + 1]);
	s[x0 + 1 + x1] = '\x0';
	return x0 + 1 + x1;
}


