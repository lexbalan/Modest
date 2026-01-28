
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "memory.h"



struct Object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};
typedef struct Object Object;

int main(void) {
	printf("memcopy test\n");

	Object o1;
	Object o2;

	o1 = (Object){
		.firstname = {'J', 'o', 'h', 'n'},
		.lastname = {'D', 'o', 'e'},
		.age = 30
	};

	const size_t len = sizeof(Object);
	printf("LEN = %zu\n", len);

	memory_copy((void *)&o2, (void *)&o1, len);

	printf("firstname = '%s'\n", (char*)&o2.firstname);
	printf("lastname = '%s'\n", (char*)&o2.lastname);
	printf("age = %d\n", o2.age);

	return 0;
}


