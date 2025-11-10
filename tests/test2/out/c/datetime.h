
#ifndef DATETIME_H
#define DATETIME_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <time.h>
#include <string.h>
#include <stdio.h>


struct datetime_Date {
	uint32_t year;
	uint8_t month;
	uint8_t day;
};
typedef struct datetime_Date datetime_Date;

struct datetime_Time {
	uint8_t hour;
	uint8_t minute;
	uint8_t second;
};
typedef struct datetime_Time datetime_Time;

struct datetime_DateTime {
	datetime_Date date;
	datetime_Time time;
};
typedef struct datetime_DateTime datetime_DateTime;
datetime_Time datetime_timeNow(void);
datetime_Date datetime_dateNow(void);
datetime_DateTime datetime_dateTimeNow(void);
uint32_t datetime_dayOfYear(void);
uint8_t datetime_dayOfWeek(void);
int32_t datetime_sprintDate(char *s);
int32_t datetime_sprintTime(char *s);
int32_t datetime_sprintDateTime(char *s);

#endif /* DATETIME_H */
