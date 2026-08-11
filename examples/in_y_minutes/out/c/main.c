
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
// This is a line comment. There are no block comments.
// sqrt
// `include` pastes a module's names directly into scope — used for C
// bindings and library modules. `import "mymodule"` instead requires a
// `mymodule.` prefix on every name it brings in (see docs/lang).
// --- Types ------------------------------------------------------------------
//
// PascalCase for types, camelCase for everything else. Base types: Bool,
// IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
// FloatX (32/64), Str8/Str16/Str32 (= []CharX), Int/Nat/Word (target width).
struct point {
	double x;
	double y;
};
typedef double Meters;
typedef uint8_t Color;
#define COLOR_RED ((Color)0)
#define COLOR_GREEN ((Color)1)
#define COLOR_BLUE ((Color)2)
typedef void Action(void);
// --- Functions ----------------------------------------------------------------

__attribute__((always_inline))
static inline double distance(struct point a, struct point b) {
	const double dx = a.x - b.x;
	const double dy = a.y - b.y;
	return sqrt(dx * dx + dy * dy);
}

static int32_t sum(int32_t n) {
	int32_t total = 0;
	int32_t i = 0;
	while (i < n) {
		total = total + i;
		++i;
	}
	return total;
}

static void announce(void) {
	printf("modest says hi\n");
}


int main(void) {
	#define n 42
	#define pi 3.14159
	int32_t i32 = n;
	double f64 = pi;
	int32_t counter = 10;
	counter = 20;
	#define fixed 30
	int32_t locked = 40;
	uint64_t w = (uint64_t)1 << 63;
	int64_t asInt = w;
	printf("w = %llx -> asInt = %lld\n", w, asInt);
	Meters height = 1.8;
	printf("height = %f\n", (double)height);
	char *const greeting = "Hello, Modest!";
	const char initial = 'M';
	printf("%s (starts with %c)\n", greeting, initial);
	int32_t arr[5] = {1, 2, 3, 4, 5};
	int32_t slice[3 - 1];
	__builtin_memcpy(&slice, &arr[1], sizeof(int32_t [3 - 1]));
	uint32_t i = 0;
	while (i < LENGTHOF(arr)) {
		printf("%d ", arr[i]);
		++i;
	}
	printf("\n");
	const struct point origin = (struct point){.x = .0, .y = .0};
	const struct point corner = (struct point){.x = 3.0, .y = 4.0};
	printf("distance = %f\n", distance(origin, corner));
	struct point p = corner;
	struct point *pp = &p;
	pp->x = 99.0;
	printf("p.x = %f\n", p.x);
	Color c = COLOR_GREEN;
	if (c == COLOR_GREEN) {
		printf("color is green\n");
	}
	uint32_t u = 0x0F;
	uint32_t v = 0x33;
	printf("u | v = %x\n", u | v);
	int32_t k = 0;
	while (k < 5) {
		++k;
		if (k == 3) {
			continue;
		}
		printf("k = %d\n", k);
	}
	int32_t j = 0;
	while (1 > 0) {
		if (j == 2) {
			break;
		}
		printf("j = %d\n", j);
		++j;
	}
	if (i32 > 0 && !(counter < 0)) {
		printf("logic works\n");
	}
	Action *cb = &announce;
	cb();
	printf("sizeof(Point) = %lu\n", sizeof(struct point));
	printf("sum(0..5) = %d\n", sum(5));
	return 0;
	#undef n
	#undef pi
	#undef fixed
}

