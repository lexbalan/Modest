
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct __anonymous_struct_3 {int32_t x;};
struct __anonymous_struct_4 {int32_t x;};
struct main_type1 {
	int32_t x;
};
struct main_type2 {
	int32_t x;
};
typedef struct main_type1 main_Type3;
#define MAIN_ZERO {.x = 0}
// Check by value

static void main_f1_val(struct main_type1 x) {
	printf("f1 x.x = %d\n", x.x);
}

static void main_f2_val(struct main_type2 x) {
	printf("f2 x.x = %d\n", x.x);
}

static void main_f3_val(main_Type3 x) {
	printf("f3 x.x = %d\n", x.x);
}

static void main_f4_val(struct __anonymous_struct_3 x) {
	printf("f4 x.x = %d\n", x.x);
}
// Check by pointer

static void main_f1_ptr(struct main_type1 *x) {
	printf("f1p x.x = %d\n", x->x);
}

static void main_f2_ptr(struct main_type2 *x) {
	printf("f2p x.x = %d\n", x->x);
}

static void main_f3_ptr(main_Type3 *x) {
	printf("f3p x.x = %d\n", x->x);
}

static void main_f4_ptr(struct __anonymous_struct_4 *x) {
	printf("f4p x.x = %d\n", x->x);
}
static struct main_type1 main_a = (struct main_type1){.x = 1};
static struct main_type2 main_b = (struct main_type2){.x = 2};
static main_Type3 main_c = (main_Type3){.x = 3};

static void main_test_by_value(void) {
	main_f1_val((struct main_type1){.x = 0});
	main_f2_val((struct main_type2){.x = 0});
	main_f3_val((main_Type3){.x = 0});
	main_f4_val((struct __anonymous_struct_3){.x = 0});
	main_f1_val((struct main_type1)MAIN_ZERO);
	main_f2_val((struct main_type2)MAIN_ZERO);
	main_f3_val((main_Type3)MAIN_ZERO);
	main_f4_val((struct __anonymous_struct_3)MAIN_ZERO);
	main_f1_val(main_a);
	main_f2_val(RAWCAST(struct main_type2, struct main_type1, main_a));
	main_f3_val(main_a);
	main_f4_val(RAWCAST(struct __anonymous_struct_3, struct main_type1, main_a));
	main_f1_val(RAWCAST(struct main_type1, struct main_type2, main_b));
	main_f2_val(main_b);
	main_f3_val(RAWCAST(main_Type3, struct main_type2, main_b));
	main_f4_val(RAWCAST(struct __anonymous_struct_3, struct main_type2, main_b));
	main_f1_val(main_c);
	main_f2_val(RAWCAST(struct main_type2, main_Type3, main_c));
	main_f3_val(main_c);
	main_f4_val(RAWCAST(struct __anonymous_struct_3, main_Type3, main_c));
}

static void main_test_by_pointer(void) {
	main_f1_ptr(&main_a);
	main_f2_ptr((struct main_type2 *)&main_a);
	main_f3_ptr((main_Type3 *)&main_a);
	main_f4_ptr((struct __anonymous_struct_4 *)&main_a);
	main_f1_ptr((struct main_type1 *)&main_b);
	main_f2_ptr(&main_b);
	main_f3_ptr((main_Type3 *)&main_b);
	main_f4_ptr((struct __anonymous_struct_4 *)&main_b);
	main_f1_ptr((struct main_type1 *)&main_c);
	main_f2_ptr((struct main_type2 *)&main_c);
	main_f3_ptr(&main_c);
	main_f4_ptr((struct __anonymous_struct_4 *)&main_c);
}

int main(void) {
	main_test_by_value();
	main_test_by_pointer();
	return 0;
}

