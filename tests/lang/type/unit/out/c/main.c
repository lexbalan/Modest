
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>



#define UNIT  {0}

static void unitFunc(void) {
	//var xunit = {}  // cannot create var with Unit type
	#define unit  {0}
	return;

#undef unit
}


int32_t main(void) {
	printf("test Unit\n");

	bool rc;
	bool success = true;

	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


