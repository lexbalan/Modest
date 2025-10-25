// tests/1.hello_world/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */
#define ARRCPY(dst, src, len) \
	do { \
		uint32_t _len = (uint32_t)(len); \
		for (uint32_t _i = 0; _i < _len; _i++) { \
			(*(dst))[_i] = (*(src))[_i]; \
		} \
	} while (0)



static bool test_generic_integer();
static bool test_generic_float();
static bool test_generic_char();
static bool test_generic_array();
static bool test_generic_record();

int main() {
	printf("generic types test\n");

	const bool t1 = test_generic_integer();
	if (t1) {
		printf("test_generic_integer passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	const bool t2 = test_generic_float();
	if (t2) {
		printf("test_generic_float passed\n");
	} else {
		printf("test_generic_float failed\n");
	}

	const bool t3 = test_generic_char();
	if (t3) {
		printf("test_generic_char passed\n");
	} else {
		printf("test_generic_char failed\n");
	}

	const bool t4 = test_generic_array();
	if (t4) {
		printf("test_generic_array passed\n");
	} else {
		printf("test_generic_array failed\n");
	}

	const bool t5 = test_generic_record();
	if (t5) {
		printf("test_generic_record passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	return 0;
}


static bool test_generic_integer() {
	// Any integer literal have GenericInteger type
	#define one  1

	// result of such expressions also have generic type
	#define two  (1 + one)

	// GenericInteger value can be implicitly casted to any Integer type
	int32_t a = one;
	uint64_t b = one;

	// to Float
	float f = one;
	double g = one;

	// and to Word8
	uint8_t x = one;


	// explicit cast GenericInteger value

	char c = (char)one;
	char16_t d = (char16_t)one;
	char32_t e = (char32_t)one;

	bool k = one != 0;

	return true;

#undef one
#undef two
}


static bool test_generic_float() {
	// Any float literal have GenericFloat type
	#define pi  3.141592653589793238462643383279502884

	// value with GenericFloat type
	// can be implicit casted to any Float type
	// (in this case value may lose precision)
	float f = pi;
	double g = pi;

	// explicit cast GenericFloat value to Int32
	int32_t x = (int32_t)pi;

	return true;

#undef pi
}


static bool test_generic_char() {
	// Any char value expression have GenericChar type
	// (you can pick GenericChar value by index of GenericString value)
	#define a  "A"

	// value with GenericChar type
	// can be implicit casted to any Char type
	char b = _CHR8(a);
	char16_t c = _CHR16(a);
	char32_t d = _CHR32(a);

	// explicit cast GenericChar value to Int32
	int32_t char_code = (int32_t)(uint32_t)_CHR32(a);

	return true;

#undef a
}


static bool test_generic_array() {
	// Any array expression have GenericArray type
	// this array expression (GenericArray of four GenericInteger items)
	#define a  {0, 1, 2, 3}

	uint32_t i = 0;
	while (i < 4) {
		printf("a[%i] = %i\n", i, (uint32_t)((uint8_t[4])a)[i]);
		i = i + 1;
	}

	if (false) {
		printf("error: a != [0, 1, 2, 3]\n");
		return false;
	}

	// value with GenericArray type
	// can be implicit casted to Array with compatible type and same size

	// implicit cast Generic([4]GenericInteger) value to [4]Int32
	int32_t b[4];
	ARRCPY(&b, &((uint8_t[4])a), LENGTHOF(b));

	if (memcmp(&b, &((int32_t[4]){0, 1, 2, 3}), sizeof(int32_t[4])) != 0) {
		printf("b != [0, 1, 2, 3]\n");
		return false;
	}

	// implicit cast Generic([4]GenericInteger) value to [4]Nat64
	int64_t c[4];
	ARRCPY(&c, &((uint8_t[4])a), LENGTHOF(c));

	if (memcmp(&c, &((int64_t[4]){0, 1, 2, 3}), sizeof(int64_t[4])) != 0) {
		printf("c != [0, 1, 2, 3]\n");
		return false;
	}

	// explicit cast Generic([4]GenericInteger) value to [10]Int32
	int32_t d[10] = a;

	if (memcmp(&d, &((int32_t[10]){0, 1, 2, 3, 0}), sizeof(int32_t[10])) != 0) {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n");
		return false;
	}

	return true;

#undef a
}


struct Point2D {
	int32_t x;
	int32_t y;
};
typedef struct Point2D Point2D;

struct Point3D {
	int32_t x;
	int32_t y;
	int32_t z;
};
typedef struct Point3D Point3D;

static bool test_generic_record() {
	// Any record expression have GenericRecord type
	// this record expression have type:
	// Generic(record {x: GenericInteger, y: GenericInteger})
	#define p  {.x = 10, .y = 20}

	// value with GenericRecord type
	// can be implicit casted to Record with same fields.

	// implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32}
	Point2D point_2d;
	point_2d = (Point2D)p;


	// explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32, z: Int32}
	Point3D point_3d;
	point_3d = (Point3D)p;

	return true;

#undef p
}


