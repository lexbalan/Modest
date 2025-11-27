
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static int32_t func1(int32_t x /* default=10 */) {
	return x;
}


static int32_t func2(int32_t a /* default=10 */, int32_t b /* default=20 */) {
	return a + b;
}


//func func3 (a: Int32 = 10, b: Int32) -> Int32 {
//	return a + b
//}

static bool test1(void) {
	const bool c0 = func1(10) == 10;
	const bool c1 = func1(10) == 10;
	const bool c2 = func1(10) == 10;
	const bool c3 = func1(20) == 20;
	const bool c4 = func1(20) == 20;
	return c0 && c1 && c2 && c3 && c4;
}


static bool test2(void) {
	const bool c0 = func2(10, 20) == 30;
	const bool c1 = func2(10, 20) == 30;
	const bool c2 = func2(10, 20) == 30;
	const bool c3 = func2(10, 20) == 30;
	const bool c4 = func2(10, 20) == 30;
	const bool c5 = func2(20, 10) == 30;
	const bool c6 = func2(20, 10) == 30;
	return c0 && c1 && c2 && c3 && c4 && c5 && c6;
}


int main(void) {
	printf("test default parameters\n");

	//func2(b=10, 10)  // error: positional argument follows keyword argument
	//func3(4)         // error: undefined parameter 'b'

	const bool test1_passed = test1();
	if (test1_passed) {
		printf("test1 passed\n");
	} else {
		printf("test1 failed\n");
	}

	const bool test2_passed = test2();
	if (test2_passed) {
		printf("test2 passed\n");
	} else {
		printf("test2 failed\n");
	}

	return 0;
}


