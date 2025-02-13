
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"



static bool main_test_generic_integer();
static bool main_test_generic_float();
static bool main_test_generic_char();
static bool main_test_generic_array();
static bool main_test_generic_record();
int main()
{
	printf("generic types test\n");

	const bool t1 = main_test_generic_integer();
	if (t1) {
		printf("test_generic_integer passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	const bool t2 = main_test_generic_float();
	if (t2) {
		printf("test_generic_float passed\n");
	} else {
		printf("test_generic_float failed\n");
	}

	const bool t3 = main_test_generic_char();
	if (t3) {
		printf("test_generic_char passed\n");
	} else {
		printf("test_generic_char failed\n");
	}

	const bool t4 = main_test_generic_array();
	if (t4) {
		printf("test_generic_array passed\n");
	} else {
		printf("test_generic_array failed\n");
	}

	const bool t5 = main_test_generic_record();
	if (t5) {
		printf("test_generic_record passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	return 0;
}


static bool main_test_generic_integer()
{
	// Any integer literal have GenericInteger type
	#define __one  1

	// result of such expressions also have generic type
	#define __two  (1 + __one)

	// GenericInteger value can be implicitly casted to any Integer type
	int32_t a = __one;
	uint64_t b = __one;

	// to Float
	float f = (float)__one;
	double g = (double)__one;

	// and to Word8
	uint8_t x = __one;


	// explicit cast GenericInteger value

	char c = (char)__one;
	uint16_t d = (uint16_t)__one;
	uint32_t e = (uint32_t)__one;

	bool k = __one != 0;

	return true;

#undef __one
#undef __two
}


static bool main_test_generic_float()
{
	// Any float literal have GenericFloat type
	#define __pi  3.141592653589793238462643383279502884

	// value with GenericFloat type
	// can be implicit casted to any Float type
	// (in this case value may lose precision)
	float f = __pi;
	double g = __pi;

	// explicit cast GenericFloat value to Int32
	int32_t x = (int32_t)__pi;

	return true;

#undef __pi
}


static bool main_test_generic_char()
{
	// Any char value expression have GenericChar type
	// (you can pick GenericChar value by index of GenericString value)
	#define __a  "A"

	// value with GenericChar type
	// can be implicit casted to any Char type
	char b = 'A';
	uint16_t c = u'A';
	uint32_t d = U'A';

	// explicit cast GenericChar value to Int32
	int32_t char_code = (int32_t)U'A';

	return true;

#undef __a
}


static bool main_test_generic_array()
{
	// Any array expression have GenericArray type
	// this array expression (GenericArray of four GenericInteger items)
	#define __a  {0, 1, 2, 3	}

	if (false) {
		printf("error: a != [0, 1, 2, 3]\n");
		return false;
	}

	// value with GenericArray type
	// can be implicit casted to Array with compatible type and same size

	// implicit cast Generic([4]GenericInteger) value to [4]Int32
	int32_t b[4];
	memset(&b, 0, sizeof b);
	memcpy(&b, &(int32_t[4])__a, sizeof b);

	if (memcmp(&b, &(int32_t[4]){0, 1, 2, 3	}, sizeof(int32_t[4])) != 0) {
		printf("b != [0, 1, 2, 3]\n");
		return false;
	}

	// implicit cast Generic([4]GenericInteger) value to [4]Nat64
	int64_t c[4];
	memset(&c, 0, sizeof c);
	memcpy(&c, &(int64_t[4])__a, sizeof c);

	if (memcmp(&c, &(int64_t[4]){0, 1, 2, 3	}, sizeof(int64_t[4])) != 0) {
		printf("c != [0, 1, 2, 3]\n");
		return false;
	}

	// explicit cast Generic([4]GenericInteger) value to [10]Int32
	int32_t d[10];
	memcpy(&d, &(int32_t[10])__a, sizeof d);

	if (memcmp(&d, &(int32_t[10]){0, 1, 2, 3, 0	}, sizeof(int32_t[10])) != 0) {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n");
		return false;
	}

	return true;

#undef __a
}



struct main_Point2D {
	int32_t x;
	int32_t y;
};
typedef struct main_Point2D main_Point2D;

struct main_Point3D {
	int32_t x;
	int32_t y;
	int32_t z;
};
typedef struct main_Point3D main_Point3D;


static bool main_test_generic_record()
{
	// Any record expression have GenericRecord type
	// this record expression have type:
	// Generic(record {x: GenericInteger, y: GenericInteger})
	#define __p  {.x = 10, .y = 20	}

	// value with GenericRecord type
	// can be implicit casted to Record with same fields.

	// implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32}
	main_Point2D point_2d;
	point_2d = (main_Point2D)__p;


	// explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32, z: Int32}
	main_Point3D point_3d;
	point_3d = (main_Point3D)__p;

	return true;

#undef __p
}

