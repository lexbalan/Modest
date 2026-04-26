
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "memory.h"
struct main_object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};

int main(void) {
	printf("memcopy test\n");
	struct main_object o1;
	struct main_object o2;
	o1 = (struct main_object){
		.firstname = "John",
		.lastname = "Doe",
		.age = 30
	};
	const size_t main_len = sizeof(struct main_object);
	printf("LEN = %zu\n", main_len);
	memory_copy((void *)&o2, (void *)&o1, main_len);
	printf("firstname = '%s'\n", o2.firstname);
	printf("lastname = '%s'\n", o2.lastname);
	printf("age = %d\n", o2.age);
	return 0;
}

