// test2

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



#define C0  40

static int32_t a0[4] = {10, 20, 30, C0};
static int32_t a1[4] = {10, 20, 30, C0};

#define PA0  (&a0)
#define PA1  (&a1)

static char ss[12] = "Hello World!";
static char *s = "Hello World!";

struct Point
{
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

static Point points[2] = {{.x = 0, .y = 0}, {.x = 1, .y = 1}};

static void swap(int32_t *_a, int32_t *sret_)
{
	int32_t a[2];
	memcpy(a, _a, sizeof(int32_t[2]));
	memcpy(sret_, &(int32_t[2]){a[1], a[0]}, sizeof(int32_t[2]));
}


static void sstr(char16_t *_s)
{
	char16_t s[3];
	memcpy(s, _s, sizeof(char16_t[3]));
	//
}


int32_t main()
{
	printf("test2\n");

	int32_t v0 = 10;
	int32_t la0[5];
	memcpy(&la0, &(int32_t[5]){10, 20, 30, C0, v0}, sizeof(int32_t[5]));
	int32_t la1[5];
	memcpy(&la1, &(int32_t[5]){10, 20, 30, C0, v0}, sizeof(int32_t[5]));

	int32_t s[2];
	swap((int32_t[2]){1, 2}, (int32_t *)&s);
	printf("s[0] = %d\n", s[0]);
	printf("s[1] = %d\n", s[1]);

	sstr(_STR16("ABC"));

	return 0;
}


