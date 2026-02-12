
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
	char buffer[32];
	memset(&buffer, 0, sizeof buffer);
	char *const s = (char *)&buffer;

	while (true) {
		printf("%s", (char *)&prompt);
		fgets((char *)&buffer, sizeof buffer, stdin);
		// convert first '\n' -> '\0'
		buffer[strcspn(s, "\n")] = '\x0';

		if (strcmp(s, "exit") == 0) {
			break;
		} else if (memcmp(&s[0], "set", sizeof(char[3 - 0])) == 0) {
			printf("SET\n");
		} else if (memcmp(&s[0], "get", sizeof(char[3 - 0])) == 0) {
			printf("GET\n");
		} else {
			printf("unknown command: %s\n", s);
		}
	}

	return 0;
}

