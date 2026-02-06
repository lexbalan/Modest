
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef struct context *ContextHandler(struct context *x);

struct x {
	struct context *c;
};

// си не позволяет создавать укзаатель на массив с элементами неполного типа
// вообще странно - но вот так
//type A = *[1]Context
//var a: *[1]Context


struct context;
static struct context *p;

struct context {
	int32_t x;
	int32_t y;
	ContextHandler *f;
};

struct zx {
	int32_t x;
	struct context c;
	ContextHandler *f;
};

#define XX  ((1.0 / 333333.0) * 333333.0)

int32_t main(void) {
	printf("xx = %f\n", (double)XX);
	printf("xx = %d\n", 1);

	// 3.1415926535897932384626433832795028841971693993751058209749445923
	#define f  3.1415926535897932384626433832795028841971693993751058209749445923
	double fx = (double)(1.0 / 7.0) * 7.0;
	fx = (double)f / 3.0;
	fx = (double)f * 2.0;
	fx = 2.0;
	double k = (double)(2.0 / 3.0);
	printf("%f\n", (double)k);
	return 0;

#undef f
}


