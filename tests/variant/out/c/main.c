
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
typedef uint32_t Error;
struct __anonymous_variant_0 {
	uint8_t tag;
	union {
		int _0;
		Error _1;
	} value;
};
// 1. Вариантный тип это ОТДЕЛЬНЫЙ ТИП
// 2. Он конструируется неявно только из значений с non-generic типом (входящим в тип-вариант)
// 3. Тег (число) равен позиционному номеру субтипа в записи вариантного типа
#define ERROR_NONE ((Error)0)
#define ERROR_SOME ((Error)1)


static struct __anonymous_variant_0 foo(void) {
	return (struct __anonymous_variant_0){.tag = 0x0, .value._0 = (int)0};
	return (struct __anonymous_variant_0){.tag = 0x1, .value._1 = ERROR_NONE};
}

int main(void) {
	struct __anonymous_variant_0 x = foo();
	return 0;
}

