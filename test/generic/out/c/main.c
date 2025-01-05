// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

static bool test_generic_integer();
static bool test_generic_float();
static bool test_generic_char();
static bool test_generic_array();
static bool test_generic_record();



int main()
{
	printf("generic types test\n");

	bool t1 = test_generic_integer();
	if (t1) {
		printf("test_generic_integer passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	bool t2 = test_generic_float();
	if (t2) {
		printf("test_generic_float passed\n");
	} else {
		printf("test_generic_float failed\n");
	}

	bool t3 = test_generic_char();
	if (t3) {
		printf("test_generic_char passed\n");
	} else {
		printf("test_generic_char failed\n");
	}

	bool t4 = test_generic_array();
	if (t4) {
		printf("test_generic_array passed\n");
	} else {
		printf("test_generic_array failed\n");
	}

	bool t5 = test_generic_record();
	if (t5) {
		printf("test_generic_record passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}

	return 0;
}


static bool test_generic_integer()
{
	//{'str': ' Any integer literal have GenericInteger type'}
	#define __one  1

	//{'str': ' result of such expressions also have generic type'}
	#define __two  (1 + __one)

	//{'str': ' GenericInteger value can be implicitly casted to any Integer type'}
	int32_t a = __one;
	uint64_t b = __one;

	//{'str': ' to Float'}
	float f = (float)__one;
	double g = (double)__one;

	//{'str': ' and to Word8'}
	uint8_t x = __one;


	//{'str': ' explicit cast GenericInteger value'}

	char c = (char)__one;
	uint16_t d = (uint16_t)__one;
	uint32_t e = (uint32_t)__one;

	bool k = __one != 0;

	return true;

#undef __one
#undef __two
}


static bool test_generic_float()
{
	//{'str': ' Any float literal have GenericFloat type'}
	#define __pi  3.141592653589793238462643383279502884

	//{'str': ' value with GenericFloat type'}
	//{'str': ' can be implicit casted to any Float type'}
	//{'str': ' (in this case value may lose precision)'}
	float f = __pi;
	double g = __pi;

	//{'str': ' explicit cast GenericFloat value to Int32'}
	int32_t x = (int32_t)__pi;

	return true;

#undef __pi
}


static bool test_generic_char()
{
	//{'str': ' Any char value expression have GenericChar type'}
	//{'str': ' (you can pick GenericChar value by index of GenericString value)'}
	#define __a  "A"

	//{'str': ' value with GenericChar type'}
	//{'str': ' can be implicit casted to any Char type'}
	char b = 'A';
	uint16_t c = u'A';
	uint32_t d = U'A';

	//{'str': ' explicit cast GenericChar value to Int32'}
	int32_t char_code = (int32_t)U'A';

	return true;

#undef __a
}


static bool test_generic_array()
{
	//{'str': ' Any array expression have GenericArray type'}
	//{'str': ' this array expression (GenericArray of four GenericInteger items)'}
	#define __a  {0, 1, 2, 3}

	if (false) {
		printf("error: a != [0, 1, 2, 3]\n");
		return false;
	}

	//{'str': ' value with GenericArray type'}
	//{'str': ' can be implicit casted to Array with compatible type and same size'}

	//{'str': ' implicit cast Generic([4]GenericInteger) value to [4]Int32'}
	int32_t b[4];
	memcpy(&b, &(int32_t[4])__a, sizeof b);

	if (memcmp(&b, &(int32_t[4]){0, 1, 2, 3}, sizeof(int32_t[4])) != 0) {
		printf("b != [0, 1, 2, 3]\n");
		return false;
	}

	//{'str': ' implicit cast Generic([4]GenericInteger) value to [4]Nat64'}
	int64_t c[4];
	memcpy(&c, &(int64_t[4])__a, sizeof c);

	if (memcmp(&c, &(int64_t[4]){0, 1, 2, 3}, sizeof(int64_t[4])) != 0) {
		printf("c != [0, 1, 2, 3]\n");
		return false;
	}

	//{'str': ' explicit cast Generic([4]GenericInteger) value to [10]Int32'}
	int32_t d[10];
	memcpy(&d, &(int32_t[10])__a, sizeof d);

	if (memcmp(&d, &(int32_t[10]){0, 1, 2, 3, 0}, sizeof(int32_t[10])) != 0) {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n");
		return false;
	}

	return true;

#undef __a
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


static bool test_generic_record()
{
	//{'str': ' Any record expression have GenericRecord type'}
	//{'str': ' this record expression have type:'}
	//{'str': ' Generic(record {x: GenericInteger, y: GenericInteger})'}
	#define __p  {.x = 10, .y = 20}

	//{'str': ' value with GenericRecord type'}
	//{'str': ' can be implicit casted to Record with same fields.'}

	//{'str': ' implicit cast Generic(record {x: GenericInteger, y: GenericInteger})'}
	//{'str': ' to record {x: Int32, y: Int32}'}
	Point2D point_2d;
	point_2d = (Point2D)__p;


	//{'str': ' explicit cast Generic(record {x: GenericInteger, y: GenericInteger})'}
	//{'str': ' to record {x: Int32, y: Int32, z: Int32}'}
	Point3D point_3d;
	point_3d = (Point3D)__p;

	return true;

#undef __p
}

