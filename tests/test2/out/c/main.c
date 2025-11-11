
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



int32_t main(void) {
	//printf("test2\n")

	const datetime_DateTime dt = datetime_dateTimeNow();
	char dateTimeStr[32];
	datetime_sprintDateTime((char *)&dateTimeStr);
	printf("datetime = '%s'\n", (char *)&dateTimeStr);

	return 0;
}


