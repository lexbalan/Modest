// examples/demo1/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




#define minNumber  0
#define maxNumber  10


int32_t get_integer(int32_t min, int32_t max);


int32_t main()
{
	const int32_t number = get_integer(minNumber, maxNumber);

	const int32_t n = 5;

	if (number < n) {
		printf("entered number (%i) is less than %i\n", number, n);
	} else if (number > n) {
		printf("entered number (%i) is greater than %i\n", number, n);
	} else {
		printf("entered number (%i) is equal with %i\n", number, n);
	}

	return 0;
}


int32_t get_integer(int32_t min, int32_t max)
{
	int32_t number;
	number = 0;

	while (true) {
		printf("enter a number (%i .. %i): ", min, max);
		scanf("%d", &number);

		if (number < min) {
			printf("number must be greater than %i, try again\n", min);
			continue;
		} else if (number > max) {
			printf("number must be less than %i, try again\n", max);
			continue;
		} else {
			break;
		}
	}

	return number;
}

