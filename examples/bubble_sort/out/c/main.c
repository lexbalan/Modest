// examples/demo1/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




#define numberOfItems  21

static int32_t array[numberOfItems] = {
	(int32_t)(int8_t)-3, (int32_t)(int8_t)-5, (int32_t)2, (int32_t)1, (int32_t)(int8_t)-1, (int32_t)0, (int32_t)(int8_t)-2, (int32_t)3, (int32_t)(int8_t)-4, (int32_t)4,
	11, 9, (int32_t)6, (int32_t)(int8_t)-7, (int32_t)-8, (int32_t)5, (int32_t)7, 10, 8, (int32_t)(int8_t)-6, (int32_t)-9
};


void bubble_sort32(int32_t *array, int32_t len)
{
	bool need_to_sort;
	need_to_sort = true;
	while (need_to_sort) {
		need_to_sort = false;
		int32_t i;
		i = 0;
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


void fill_array(int32_t *array, int32_t len);
void print_array(int32_t *array, int32_t len);


int32_t main()
{
	//fill_array(&array, numberOfItems)

	printf("array before:\n");
	print_array((int32_t *)(int32_t *)&array, (int32_t)numberOfItems);
	printf("\n");

	bubble_sort32((int32_t *)(int32_t *)&array, (int32_t)numberOfItems);

	printf("array after:\n");
	print_array((int32_t *)(int32_t *)&array, (int32_t)numberOfItems);
	printf("\n");

	return 0;
}


void print_array(int32_t *array, int32_t len)
{
	printf("\n");
	int32_t i;
	i = 0;
	while (i < len) {
		printf("array[%i] = %i\n", i, array[i]);
		i = i + 1;
	}
}


int32_t get_integer(int32_t min, int32_t max);

void fill_array(int32_t *array, int32_t len)
{
	#define min  (-1000)
	#define max  1000
	int32_t i;
	i = 0;
	while (i < len) {
		printf("[%i] ", i);
		const int32_t x = get_integer((int32_t)min, (int32_t)max);
		array[i] = x;
		i = i + 1;
	}
#undef min
#undef max
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

