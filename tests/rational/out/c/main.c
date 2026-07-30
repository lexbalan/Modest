
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#define HALF 0.5
#define QUARTER 0.25
#define EIGHTH 0.125
#define PI 3.14159
#define NEG_PI (-3.75)


bool main_testGenericAdaptation(void) {
	float asFloat32 = HALF;
	double asFloat64 = HALF;
	if (asFloat32 != HALF) {
		printf("error: asFloat32 != 0.5\n");
		return false;
	}
	if (asFloat64 != HALF) {
		printf("error: asFloat64 != 0.5\n");
		return false;
	}
	printf("passed: generic adaptation test\n");
	return true;
}
#define SUM (1.5 + 2.25)
#define DIFF (5.5 - 1.25)
#define PROD (1.5 * 2.0)
#define QUOT (7.0 / 4.0)
#define NEGATED (-SUM)
#define JUST (+1.5)


bool main_testConstFolding(void) {
	if (SUM != 3.75) {
		printf("error: sum != 3.75\n");
		return false;
	}
	if (DIFF != 4.25) {
		printf("error: diff != 4.25\n");
		return false;
	}
	if (PROD != 3.0) {
		printf("error: prod != 3.0\n");
		return false;
	}
	if (QUOT != 1.75) {
		printf("error: quot != 1.75\n");
		return false;
	}
	if (NEGATED != -3.75) {
		printf("error: negated != -3.75\n");
		return false;
	}
	#define chained (HALF + QUARTER + EIGHTH)
	if (chained != 0.875) {
		printf("error: chained != 0.875\n");
		return false;
	}
	printf("passed: const folding test\n");
	return true;
	#undef chained
}

bool main_testTruncatingConstruction(void) {
	int32_t truncPos = (int32_t)PI;
	if (truncPos != 3) {
		printf("error: Int32 pi != 3 (got %d)\n", truncPos);
		return false;
	}
	int32_t truncNeg = (int32_t)NEG_PI;
	if (truncNeg != -3) {
		printf("error: Int32 negPi != -3 (got %d)\n", truncNeg);
		return false;
	}
	int8_t truncSmall = (int8_t)NEG_PI;
	if (truncSmall != -3) {
		printf("error: Int8 negPi != -3\n");
		return false;
	}
	uint32_t truncNat = (uint32_t)PI;
	if (truncNat != 3) {
		printf("error: Nat32 pi != 3 (got %d)\n", truncNat);
		return false;
	}
	printf("passed: truncating construction test\n");
	return true;
}


bool main_testFloatComparison(void) {
	double f64 = PI;
	float f32 = PI;
	if (f64 <= 3.0) {
		printf("error: f64 <= 3.0\n");
		return false;
	}
	if (!(f64 < 3.2)) {
		printf("error: not (f64 < 3.2)\n");
		return false;
	}
	if (!(f64 >= PI)) {
		printf("error: not (f64 >= pi)\n");
		return false;
	}
	if (f64 != PI) {
		printf("error: f64 != pi\n");
		return false;
	}
	if (f32 != (float)PI) {
		printf("error: f32 != Float32 pi\n");
		return false;
	}
	printf("passed: float comparison test\n");
	return true;
}

bool main_testLocalRationalConst(void) {
	#define localHalf 0.5
	#define localSum (localHalf + 0.25)
	if (localSum != 0.75) {
		printf("error: localSum != 0.75\n");
		return false;
	}
	double asFloat = localSum;
	if (asFloat != 0.75) {
		printf("error: asFloat != 0.75\n");
		return false;
	}
	printf("passed: local rational const test\n");
	return true;
	#undef localHalf
	#undef localSum
}


int main(void) {
	printf("test rational\n");
	bool result = true;
	result = main_testGenericAdaptation() && result;
	result = main_testConstFolding() && result;
	result = main_testTruncatingConstruction() && result;
	result = main_testFloatComparison() && result;
	result = main_testLocalRationalConst() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

