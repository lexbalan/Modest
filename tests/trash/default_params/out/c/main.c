
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static int32_t main_func1(int32_t x) {
	return x;
}

static int32_t main_func2(int32_t a, int32_t b) {
	return a + b;
}
//func func3 (a: Int32 = 10, b: Int32) -> Int32 {
//	return a + b
//}

static bool main_test1(void) {
	const bool main_c0 = main_func1(10) == 10;
	const bool main_c1 = main_func1(10) == 10;
	const bool main_c2 = main_func1(10) == 10;
	const bool main_c3 = main_func1(20) == 20;
	const bool main_c4 = main_func1(20) == 20;
	return main_c0 && main_c1 && main_c2 && main_c3 && main_c4;
}

static bool main_test2(void) {
	const bool main_c0 = main_func2(10, 20) == 30;
	const bool main_c1 = main_func2(10, 20) == 30;
	const bool main_c2 = main_func2(10, 20) == 30;
	const bool main_c3 = main_func2(10, 20) == 30;
	const bool main_c4 = main_func2(10, 20) == 30;
	const bool main_c5 = main_func2(20, 10) == 30;
	const bool main_c6 = main_func2(20, 10) == 30;
	return main_c0 && main_c1 && main_c2 && main_c3 && main_c4 && main_c5 && main_c6;
}

int main(void) {
	printf("test default parameters\n");
	const bool main_test1_passed = main_test1();
	if (main_test1_passed) {
		printf("test1 passed\n");
	} else {
		printf("test1 failed\n");
	}
	const bool main_test2_passed = main_test2();
	if (main_test2_passed) {
		printf("test2 passed\n");
	} else {
		printf("test2 failed\n");
	}
	return 0;
}

