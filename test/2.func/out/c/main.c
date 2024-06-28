// test/2.func/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




// declare function f0
void func0();


// define function f1
void func1()
{
	printf("func1 was called\n");
}


void print_ab(int32_t a, int32_t b)
{
	printf("print_ab(a=%i, b=%i)\n", a, b);
}


int32_t sum(int32_t a, int32_t b)
{
	return a + b;
}


// define function main
int32_t main()
{
	printf("test func\n");

	// call declared & defined functions
	func0();
	func1();

	// call function with two arguments
	print_ab(10, 20);

	// call function with two arguments and return value
	const int32_t arg_a = 1;
	const int32_t arg_b = 2;
	const int32_t sum_result = sum(arg_a, arg_b);
	printf("sum(%i, %i) == %i\n", arg_a, arg_b, sum_result);


	void *fptr;
	fptr = &sum;
	// call function with two arguments and return value
	const int32_t arg_a2 = 1;
	const int32_t arg_b2 = 2;
	const int32_t fptr_result = ((int32_t (*) (int32_t a, int32_t b))fptr)(arg_a2, arg_b2);
	printf("fptr(%i, %i) == %i\n", arg_a2, arg_b2, fptr_result);

	return 0;
}


// define function f0
void func0()
{
	printf("func0 was called\n");
}

