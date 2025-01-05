// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"


struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;


static int32_t glb_i0 = 0;
static int32_t glb_i1 = 321;

static Point glb_r0 = {};
static Point glb_r1 = {.x = 20, .y = 10};

static int32_t glb_a0[10] = (int32_t[10]){};
static int32_t glb_a1[10] = (int32_t[10]){64, 53, 42};


int main()
{
	printf("test assignation\n");

	//{'str': ' -----------------------------------'}
	//{'str': ' Global'}

	//{'str': ' copy integers by value'}
	glb_i0 = glb_i1;
	printf("glb_i0 = %i\n", glb_i0);


	//{'str': ' copy arrays by value'}
	memcpy(&glb_a0, &glb_a1, sizeof glb_a0);

	printf("glb_a0[0] = %i\n", glb_a0[0]);
	printf("glb_a0[1] = %i\n", glb_a0[1]);
	printf("glb_a0[2] = %i\n", glb_a0[2]);


	//{'str': ' copy records by value'}
	glb_r0 = glb_r1;

	printf("glb_r0.x = %i\n", glb_r0.x);
	printf("glb_r0.y = %i\n", glb_r0.y);


	//{'str': ' -----------------------------------'}
	//{'str': ' Local'}

	//{'str': ' copy integers by value'}
	int32_t loc_i0 = 0;
	int32_t loc_i1 = 123;

	loc_i0 = loc_i1;

	printf("loc_i0 = %i\n", loc_i0);

	//{'str': ' copy arrays by value'}
	//{'str': ' C backend will be use memcpy()'}
	int32_t loc_a0[10];
	memset(&loc_a0, 0, sizeof loc_a0);
	int32_t loc_a1[10];
	memcpy(&loc_a1, &(int32_t[10]){42, 53, 64}, sizeof loc_a1);

	memcpy(&loc_a0, &loc_a1, sizeof loc_a0);

	printf("loc_a0[0] = %i\n", loc_a0[0]);
	printf("loc_a0[1] = %i\n", loc_a0[1]);
	printf("loc_a0[2] = %i\n", loc_a0[2]);


	//{'str': ' copy records by value'}
	//{'str': ' C backend will be use memcpy()'}
	Point loc_r0 = (Point){};
	Point loc_r1 = (Point){.x = 10, .y = 20};

	loc_r0 = loc_r1;

	printf("loc_r0.x = %i\n", loc_r0.x);
	printf("loc_r0.y = %i\n", loc_r0.y);


	//{'str': ' error: closed arrays of closed arrays are denied'}
	//l
	//e
	//t
	//
	//d
	//i
	//m
	//1
	//
	//=
	//
	//1
	//5
	//

	//
	//l
	//e
	//t
	//
	//d
	//i
	//m
	//2
	//
	//=
	//
	//1
	//6
	//

	//

	//
	//v
	//a
	//r
	//
	//a
	//a
	//:
	//
	//[
	//d
	//i
	//m
	//1
	//]
	//[
	//d
	//i
	//m
	//2
	//]
	//I
	//n
	//t
	//3
	//2
	//

	//

	//
	//v
	//a
	//r
	//
	//i
	//
	//=
	//
	//0
	//

	//
	//w
	//h
	//i
	//l
	//e
	//
	//i
	//
	//<
	//
	//1
	//6
	//
	//{
	//

	//
	//
	//v
	//a
	//r
	//
	//j
	//
	//=
	//
	//0
	//

	//
	//
	//w
	//h
	//i
	//l
	//e
	//
	//j
	//
	//<
	//
	//1
	//6
	//
	//{
	//

	//
	//
	//
	//a
	//a
	//[
	//i
	//]
	//[
	//j
	//]
	//
	//=
	//
	//i
	//
	//*
	//
	//j
	//

	//
	//
	//
	//j
	//
	//=
	//
	//j
	//
	//+
	//
	//1
	//

	//
	//
	//}
	//

	//
	//
	//i
	//
	//=
	//
	//i
	//
	//+
	//
	//1
	//

	//
	//}
	//

	//

	//
	//i
	//
	//=
	//
	//0
	//

	//
	//w
	//h
	//i
	//l
	//e
	//
	//i
	//
	//<
	//
	//1
	//6
	//
	//{
	//

	//
	//
	//v
	//a
	//r
	//
	//k
	//
	//=
	//
	//0
	//

	//
	//
	//w
	//h
	//i
	//l
	//e
	//
	//k
	//
	//<
	//
	//1
	//6
	//
	//{
	//

	//
	//
	//
	//p
	//r
	//i
	//n
	//t
	//f
	//(
	//"
	//a
	//a
	//[
	//%
	//i
	//]
	//[
	//%
	//i
	//]
	//
	//=
	//
	//%
	//i
	//\
	//n
	//"
	//,
	//
	//i
	//,
	//
	//k
	//,
	//
	//a
	//a
	//[
	//i
	//]
	//[
	//k
	//]
	//)
	//

	//
	//
	//
	//k
	//
	//=
	//
	//k
	//
	//+
	//
	//1
	//

	//
	//
	//}
	//

	//
	//
	//i
	//
	//=
	//
	//i
	//
	//+
	//
	//1
	//

	//
	//}
	//

	//

	//

	//
	//l
	//e
	//t
	//
	//x
	//a
	//
	//=
	//
	//a
	//a
	//[
	//3
	//]
	//

	//

	//
	//i
	//
	//=
	//
	//0
	//

	//
	//w
	//h
	//i
	//l
	//e
	//
	//i
	//
	//<
	//
	//d
	//i
	//m
	//2
	//
	//{
	//

	//
	//
	//p
	//r
	//i
	//n
	//t
	//f
	//(
	//"
	//x
	//a
	//[
	//%
	//i
	//]
	//
	//=
	//
	//%
	//i
	//\
	//n
	//"
	//,
	//
	//i
	//,
	//
	//x
	//a
	//[
	//i
	//]
	//)
	//

	//
	//
	//i
	//
	//=
	//
	//i
	//
	//+
	//
	//1
	//

	//
	//}


	return 0;
}

