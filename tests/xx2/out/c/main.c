
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



struct context {
	int32_t x;
	int32_t y;
};

typedef struct context Context2;

static void f0(struct context c) {
	(void)c;
}


static void f1(Context2 c) {
	(void)c;
}


int32_t main(void) {
	f0((struct context){.x = 0, .y = 0});
	f1((Context2){.x = 0, .y = 0});
	return 0;
}


