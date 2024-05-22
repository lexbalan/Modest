// test/22.arr_param/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




struct swap_x {int32_t a[2];};
struct swap_retval {int32_t a[2];};
struct swap_retval swap(struct swap_x x);


struct swap_retval swap(struct swap_x x)
{
	int32_t out[2];
	out[0] = x.a[1];
	out[1] = x.a[0];
	return *(struct swap_retval *)&out;
}


struct ret_str_retval {char a[7];};
struct ret_str_retval ret_str()
{
	return *(struct ret_str_retval *)&"hello!\n";
}


// error: closed arrays of closed arrays are denied
/*func ret_str2() -> [2][10]Char8 {
	return ["ab", "cd"]
}*/


// error: closed arrays of closed arrays are denied
/*func kk(x: [2][10]Char8) {
	printf("%c\n", x[0][0])
	printf("%c\n", x[0][1])
	printf("%c\n", x[0][2])
	printf("%c\n", x[0][3])
	printf("%c\n", x[0][4])
	printf("%c\n", x[0][5])
	printf("%c\n", x[0][6])
	printf("%c\n", x[0][7])
	printf("%c\n", x[0][8])
	printf("%c\n", x[0][9])
	printf("\n")

	printf("%c\n", x[1][0])
	printf("%c\n", x[1][1])
	printf("%c\n", x[1][2])
	printf("%c\n", x[1][3])
	printf("%c\n", x[1][4])
	printf("%c\n", x[1][5])
	printf("%c\n", x[1][6])
	printf("%c\n", x[1][7])
	printf("%c\n", x[1][8])
	printf("%c\n", x[1][9])
	printf("\n")
}*/



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

	struct swap_retval b = swap(*(struct swap_x *)&a);

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

