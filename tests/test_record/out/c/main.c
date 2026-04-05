
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
typedef int32_t MyInt;
struct point {

	uint64_t xx;

	uint64_t yy;
};
static struct point p0 = (struct point){
	.xx = 0x1ULL,
	.yy = 0x2ULL
};
static struct point points[3] = {
	(struct point){.xx = 0x0ULL, .yy = 0xAULL},
	(struct point){.xx = 0xAULL, .yy = 0x14ULL},
	(struct point){.xx = 0x1EULL, .yy = 0x28ULL}
};

int main(void) {
	const struct point p0 = (struct point){.xx = 0xAULL, .yy = 0xAULL};
	struct point *const p1 = (struct point *)__builtin_memcpy(malloc(sizeof(struct point)), &(struct point){.xx = 0xAULL, .yy = 0xAULL}, sizeof(struct point));
	return 0;
}

