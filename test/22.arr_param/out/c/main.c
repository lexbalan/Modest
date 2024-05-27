// test/22.arr_param/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




struct swap_in {int32_t a[2];};
struct swap_retval {int32_t a[2];};
struct swap_retval swap(struct swap_in in)
{
	int32_t out[2];
	out[0] = in.a[1];
	out[1] = in.a[0];
	return *(struct swap_retval *)&out;
}


struct ret_str_retval {char a[8];};
struct ret_str_retval ret_str()
{
	return *(struct ret_str_retval *)&"hello!\n";
}


static int32_t global_array[2] = (int32_t[2]){1, 2};


typedef struct {
	int32_t x;
	int32_t y;
} Point;

typedef struct {
	char x[10];
} Pod;


int main()
{
	// function returns array
	struct ret_str_retval returned_string;
	*(struct ret_str_retval *)&returned_string = ret_str();
	printf("returned_string = %s", (char *)&returned_string);

	// function receive array & return array
	int32_t a[2];

	a[0] = 10;
	a[1] = 20;

	printf("before swap:\n");
	printf("a[0] = %i\n", a[0]);
	printf("a[1] = %i\n", a[1]);

	struct swap_retval b = swap(*(struct swap_in *)&a);

	printf("after swap:\n");
	printf("b[0] = %i\n", b.a[0]);
	printf("b[1] = %i\n", b.a[1]);

	/*var w: [2][10]Char8
	w[0] = "hello"
	w[1] = "world"
	let u = w
	kk(u)*/

	return 0;
}

