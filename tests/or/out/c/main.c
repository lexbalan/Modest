
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
// 1. OR тип это ОТДЕЛЬНЫЙ ТИП
// 2. Он конструируется неявно только из значений с non-generic типом
typedef uint32_t Error;
#define ERROR_NONE ((Error)0)
#define ERROR_SOME ((Error)1)

static /*Type Variant*/ foo(void) {
	return /*cons value or*/;
}


int main(void) {
	const Error x = ERROR_SOME;
	if (x == ERROR_NONE) {
		printf("No error\n");
	} else {
		printf("Error occurred\n");
	}
	return 0;
}

