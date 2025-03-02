
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"


#define defaultPrompt  "# "

static char prompt[32] = defaultPrompt;

int32_t main()
{
	char input[32];
	memset(&input, 0, sizeof input);
	char *const s = (char *)&input;

	while (true) {
		printf("%s", (char *)&prompt);
		scanf("%s", s);

		if ((strcmp(s, "beep") == 0)) {
			printf("\a");
		} else if ((strcmp(s, "exit") == 0)) {
			break;
		} else {
			printf("s = %s\n", s);
		}
	}

	return 0;
}

