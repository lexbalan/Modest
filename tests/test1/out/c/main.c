
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


/* anonymous records */
struct __anonymous_struct_1
{
	int32_t x;  // hi!
	int32_t y;  // lo?
};

static void testFixed()
{
	const fixed32_Fixed32 fp0 = fixed32_create(1, 2, 4);
	printf("fp0 = 0x%08x ", fp0);
	fixed32_print(fp0);
	printf("\n");

	const fixed32_Fixed32 fp1 = fixed32_create(1, 1, 2);
	printf("fp1 = 0x%08x ", fp1);
	fixed32_print(fp1);
	printf("\n");

	const fixed32_Fixed32 fp2 = fixed32_create(1, 1, 3);
	printf("fp2 = 0x%08x ", fp2);
	fixed32_print(fp2);
	printf("\n");

	const fixed32_Fixed32 fp3 = fixed32_create(1, 2, 128);
	printf("fp3 = 0x%08x ", fp3);
	fixed32_print(fp3);
	printf("\n");

	const fixed32_Fixed32 fp4 = fixed32_add(fp0, fp1);
	printf("fp4 = 0x%08x ", fp4);
	fixed32_print(fp4);
	printf("\n");

	const fixed32_Fixed32 fp5 = fixed32_mul(fp0, fp1);
	printf("fp5 = 0x%08x ", fp5);
	fixed32_print(fp5);
	printf("\n");

	const fixed32_Fixed32 one = fixed32_create(1, 0, 1);
	const fixed32_Fixed32 two = fixed32_create(2, 0, 1);
	const fixed32_Fixed32 dv = fixed32_div(one, two);
	printf("dv = 0x%08x ", dv);
	fixed32_print(dv);
	printf("\n");

	const fixed32_Fixed32 pi = fixed32_create(3, 1415, 10000);
	printf("pi = 0x%08x ", pi);
	fixed32_print(pi);
	printf("\n");

	const fixed32_Fixed32 tr = fixed32_trunc(pi);
	printf("trunc(pi) = 0x%08x ", tr);
	fixed32_print(tr);
	printf("\n");

	const fixed32_Fixed32 fr = fixed32_fract(pi);
	printf("fract(pi) = 0x%08x ", fr);
	fixed32_print(fr);
	printf("\n");

	// ok!
	//	let dv2 = fixed32.div(pi, two)
	//	printf("dv2 = 0x%08x ", dv2)
	//	fixed32.print(dv2)
	//	printf("\n")

	const fixed32_Fixed32 zero = fixed32_fromInt16(0);

	// -1+0/1 = ok
	const fixed32_Fixed32 mone = fixed32_sub(zero, one);
	printf("mone = 0x%08x ", mone);
	fixed32_print(mone);
	printf("\n");

	fixed32_Fixed32 t2 = two;

	const fixed32_Fixed32 oone = fixed32_add(t2, mone);
	printf("oone = 0x%08x ", oone);
	fixed32_print(oone);
	printf("\n");

	const fixed32_Fixed32 semi = fixed32_sub(zero, fixed32_fromInt16(180));
	printf("semi = 0x%08x ", semi);
	fixed32_print(semi);
	printf("\n");

	//let xx = fixed32.fromInt16(380)
	const fixed32_Fixed32 dv2 = fixed32_div(semi, two);
	printf("dv2 = 0x%08x ", dv2);
	fixed32_print(dv2);
	printf("\n");
}


typedef int32_t NewType;
#define newZero  ((NewType)0)
#define newOne  ((NewType)1)
#define newTwo  ((NewType)2)
#define newThree  ((NewType)3)

static void brandCheck()
{
	NewType a;
	NewType b;
	const NewType x = a + b + newZero + (NewType)0;
	int16_t y = (int16_t)x;
	int32_t xx = (int32_t)x;
	//
}


static int32_t add(int32_t a, int32_t b)
{
	return a + b;
}


//const yx = add(2, 2)

static int32_t v0;

void main_f0()
{
}


int32_t i32;

__attribute__((aligned(4)))
static uint32_t u32;

static uint32_t a32;

static uint8_t prev_p[10];
static void xxx(uint8_t *p)
{
	uint8_t *const xp = (uint8_t *)(uint8_t *)p;
	if (memcmp(&prev_p, xp, sizeof(uint8_t[10])) != 0)
	{
		memcpy(&prev_p, xp, sizeof(uint8_t[10]));
	}
}


static void mzero(void *p, uint32_t size)
{
	uint8_t *const px = (uint8_t *)(uint8_t *)p;
	memset(px, 0, sizeof(uint8_t[size]));
}


static void mcopy(void *dst, void *src, uint32_t size)
{
	uint8_t *const pd = (uint8_t *)(uint8_t *)dst;
	uint8_t *const ps = (uint8_t *)(uint8_t *)src;
	memcpy(pd, ps, sizeof(uint8_t[size]));
}


static bool mcmp(void *a, void *b, uint32_t size)
{
	uint8_t *const pa = (uint8_t *)(uint8_t *)a;
	uint8_t *const pb = (uint8_t *)(uint8_t *)b;
	return memcmp(pa, pb, sizeof(uint8_t[size])) == 0;
}


void main_sbuf(void *p, uint32_t size)
{
	uint8_t *const px = (uint8_t *)(uint8_t *)p;
	uint8_t buf[size];
	memcpy(&buf, px, sizeof(uint8_t[size]));
	uint32_t i = 0;
	while (i < size)
	{
		const uint8_t x = buf[i];
		i = i + 1;
	}
}


static volatile int *const (*xx)[];
static volatile int yy[10];

extern int32_t ma();

//func ab_ret (a: Int32, b: Int32) -> record {a: Int32, b: Int32} {
//	return {a=a, b=b}
//}
//
//func ab_test () -> Unit {
//	let x = ab_ret(9, 11)
//	printf("x.a = %i\n", x.a)
//	printf("x.a = %i\n", x.b)
//}

#define ca  4
static int32_t va = ca;

#define p0  {.x = 1, .y = 2}
static struct
{uint8_t x; uint8_t y;
} p = p0;

#define ini  {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}

extern volatile int32_t yyy[32];

static void divtest()
{
	int32_t a = 7;
	int32_t b = -3;
	printf("%d / %d = %d\n", a, b, a / b);
	printf("%d %% %d = %d\n", a, b, a % b);
}


static int32_t argtest(int32_t a, int32_t b /* default=0 */)
{
	return a + b;
}


int32_t main()
{
	//ab_test()

	argtest(1, 0);
	argtest(1, 2);
	argtest(1, 3);

	testFixed();

	divtest();

	main_Point p;
	printf("test %s\n", main_cq);
	printf("test %d\n", v0);
	//f0()

	printf("p0.x = %d\n", ((struct
{uint8_t x; uint8_t y;
	})p0).x);

	int32_t x1 = 5;
	int32_t x2 = 15;

	uint8_t w0[10] = ini;
	int32_t a0[10] = ini;
	//
	int32_t a1[5];
	memcpy(&a1, (int32_t(*)[7 - 2])&a0[2], sizeof(int32_t[5]));
	//
	int32_t a2[20];
	memcpy((int32_t(*)[15 - 5])&a2[5], &a0, sizeof(int32_t[15 - 5]));
	//
	int32_t a3[20];
	memcpy((int32_t(*)[x2 - x1])&a3[x1], &a0, sizeof(int32_t[x2 - x1]));
	//
	memcpy((int32_t(*)[12 - 3])&a3[3], (int32_t(*)[13 - 4])&a2[4], sizeof(int32_t[12 - 3]));
	//
	memcpy(&a0, (int32_t(*)[13 - 3])&a3[3], sizeof(int32_t[10]));
	//
	memset((int32_t(*)[13 - 3])&a3[3], 0, sizeof(int32_t[13 - 3]));

	int32_t a4[10] = {0};

	xxx((uint8_t *)&w0);

	uint8_t yy = 0x1;
	uint8_t we = yy;

	int *const pa2 = (int *)(int *)&a2;

	if (memcmp(pa2, &a0, sizeof(int[10])) == 0)
	{
		printf("eq!\n");
	}
	else
	{
		printf("eq!\n");
	}

	//	let x = Int8 -1
	//
	//	i32 = Int32 x
	//	u32 = Nat32 x

	// не проверяет дубликаты имен!
	int32_t x = 1;
	//var y: Int32 = 0x1  // error!
	uint32_t z = 0x1;
	uint32_t w = 0x1;

	const int8_t i8 = (int8_t)-1;
	const uint32_t n32 = (uint32_t)abs((int)i8);
	const int32_t i32 = (int32_t)i8;
	const uint32_t w32 = (uint32_t)(uint8_t)i8;

	if (((int32_t)(int8_t)-1 == -1) && (i32 == -1))
	{
		printf("Int8 -1 -> Int32 (-1) test passed\n");
	}
	else
	{
		printf("Int8 -1 -> Int32 test failed\n");
	}

	if (((uint32_t)abs((int)(int8_t)-1) == 1) && (n32 == 1))
	{
		printf("Int8 -1 -> Nat32 (1) test passed\n");
	}
	else
	{
		printf("Int8 -1 -> Nat32 test failed\n");
	}

	if (((uint32_t)(uint8_t)(int8_t)-1 == 0xFF) && (w32 == 0xFF))
	{
		printf("Int8 -1 -> Word32 (0xff) test passed\n");
	}
	else
	{
		printf("Int8 -1 -> Word32 test failed\n");
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0;
}


