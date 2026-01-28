
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static void func1(void) {
	printf("func1 was called\n");
}


static void print_ab(int32_t a, int32_t b) {
	printf("print_ab(a=%i, b=%i)\n", a, b);
}


static int32_t sum(int32_t a, int32_t b) {
	return a + b;
}



// define function main

static void func0(void);

int main(void) {
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


	int32_t(*fptr)(int32_t a, int32_t b) = &sum;
	// call function with two arguments and return value
	const int32_t arg_a2 = 1;
	const int32_t arg_b2 = 2;
	const int32_t fptr_result = fptr(arg_a2, arg_b2);
	printf("fptr(%i, %i) == %i\n", arg_a2, arg_b2, fptr_result);

	return 0;
}


static void func0(void) {
	printf("func0 was called\n");
}


