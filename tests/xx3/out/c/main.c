
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>




struct context;
typedef struct context Context;


typedef Context *ContextHandler(Context *x);




struct x {
	Context *c;
};

// си не позволяет создавать укзаатель на массив с элементами неполного типа
// вообще странно - но вот так
//type A = *[1]Context
//var a: *[1]Context



static Context *p;


struct zx;


struct context {
	int32_t x;
	int32_t y;
	ContextHandler *f;
	struct zx *pz;
};




struct zx {
	int32_t x;
	Context c;
	ContextHandler *f;
	struct zx *pz;
};

typedef struct zx ZZ;

#define X  1.5
#define XX  ((X / 333333.0) * 333333.0)
#define Y  ((int)X)

int32_t main(void) {
	Context c;
	struct zx x;
	ZZ z;

	printf("xx = %f\n", (double)XX);
	printf("y = %d\n", (int32_t)Y);

	// 3.1415926535897932384626433832795028841971693993751058209749445923
	#define f  3.1415926535897932384626433832795028841971693993751058209749445923
	double fx = (double)(1.0 / 7.0) * 7.0;
	printf("fx = %f\n", (double)fx);
	fx = (double)f / 3.0;
	fx = (double)f * 2.0;
	fx = 2.0;
	double k = (double)(2.0 / 3.0);
	printf("%f\n", (double)k);
	return 0;

#undef f
}


