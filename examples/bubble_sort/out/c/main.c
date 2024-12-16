// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

static int32_t array[21] = (int32_t[21]){
	-3, -5, 2, 1, -1, 0, -2, 3, -4, 4,
	11, 9, 6, -7, -8, 5, 7, 10, 8, -6, -9
};


static void bubble_sort32(int32_t *array, int32_t len)
{
	bool need_to_sort = true;
	while (need_to_sort) {
		need_to_sort = false;
		int32_t i = 0;
		while (i < len - 1) {
			const int32_t i0 = array[i];
			const int32_t i1 = array[i + 1];

			if (i0 > i1) {
				// swap
				array[i] = i1;
				array[i + 1] = i0;
				need_to_sort = true;
				break;
			}

			i = i + 1;
		}
	}
}
static void print_array(int32_t *array, int32_t len);



int32_t main()
{
	//fill_array(&array, lengthof(array))

	printf("array before:\n");
	print_array((int32_t *)&array, LENGTHOF(array));
	printf("\n");

	bubble_sort32((int32_t *)&array, LENGTHOF(array));

	printf("array after:\n");
	print_array((int32_t *)&array, LENGTHOF(array));
	printf("\n");

	return 0;
}


static void print_array(int32_t *array, int32_t len)
{
	printf("\n");
	int32_t i = 0;
	while (i < len) {
		printf("array[%i] = %i\n", i, array[i]);
		i = i + 1;
	}
}
static int32_t get_number(int32_t min, int32_t max);



static void fill_array(int32_t *array, int32_t len)
{
	#define __min  (-1000)
	#define __max  1000
	int32_t i = 0;
	while (i < len) {
		printf("[%i] ", i);
		const int32_t x = get_number(__min, __max);
		array[i] = x;
		i = i + 1;
	}

#undef __min
#undef __max
}


static int32_t get_number(int32_t min, int32_t max)
{
	int32_t number = 0;

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

