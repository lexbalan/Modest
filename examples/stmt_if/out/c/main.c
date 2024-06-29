// examples/stmt_if/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
/* forward type declaration */
/* anon recs */




int main()
{
	printf("if statement example\n");

	int32_t a;
	int32_t b;

	printf("enter a: ");
	scanf("%d", &a);
	printf("enter b: ");
	scanf("%d", &b);

	if (a > b) {
		printf("a > b\n");
	} else if (a < b) {
		printf("a < b\n");
	} else {
		printf("a == b\n");
	}

	return 0;
}

