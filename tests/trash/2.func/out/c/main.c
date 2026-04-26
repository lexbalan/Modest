
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void main_func1(void) {
	printf("func1 was called\n");
}

static void main_print_ab(int32_t a, int32_t b) {
	printf("print_ab(a=%i, b=%i)\n", a, b);
}

static int32_t main_sum(int32_t a, int32_t b) {
	return a + b;
}
static void main_func0(void);

int main(void) {
	printf("test func\n");
	main_func0();
	main_func1();
	main_print_ab(10, 20);
	const int32_t main_arg_a = 1;
	const int32_t main_arg_b = 2;
	const int32_t main_sum_result = main_sum(main_arg_a, main_arg_b);
	printf("sum(%i, %i) == %i\n", main_arg_a, main_arg_b, main_sum_result);
	int32_t (*fptr)(int32_t a, int32_t b) = &main_sum;
	const int32_t main_arg_a2 = 1;
	const int32_t main_arg_b2 = 2;
	const int32_t main_fptr_result = fptr(main_arg_a2, main_arg_b2);
	printf("fptr(%i, %i) == %i\n", main_arg_a2, main_arg_b2, main_fptr_result);
	return 0;
}

static void main_func0(void) {
	printf("func0 was called\n");
}

