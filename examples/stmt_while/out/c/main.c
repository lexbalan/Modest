// examples/stmt_while/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
	printf("while statement test\n");

	int32_t a;
	a = 0;
	#define b  10

	while (a < b) {
		printf("a = %d\n", a);
		a = a + 1;
	}

	return 0;
#undef b
}

